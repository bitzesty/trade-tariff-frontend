require "api_entity"

class ApplicationController < ActionController::Base
  protect_from_forgery
  include TradeTariffFrontend::ViewContext::Controller

  before_action :set_last_updated
  before_action :set_cache
  before_action :search_query
  before_action :maintenance_mode_if_active
  before_action :bots_no_index_if_historical

  layout :set_layout

  rescue_from Errno::ECONNREFUSED do |e|
    render plain: '', status: :error
  end

  rescue_from ApiEntity::NotFound do ||
    render plain: '404', status: 404
  end

  rescue_from ApiEntity::Error do |e|
    render plain: '', status: :error
  end

  rescue_from URI::InvalidURIError do |e|
    render plain: '404', status: 404
  end

  def url_options
    return super unless search_invoked?
    return { country: search_query.country }.merge(super) if search_query.date.today?
    {
      year: search_query.date.year,
      month: search_query.date.month,
      day: search_query.date.day,
      country: search_query.country
    }.merge(super)
  end

  private

  def set_last_updated
    @tariff_last_updated ||= TariffUpdate.latest_applied_import_date
  end

  def search_invoked?
    params[:q].present? || params[:day].present? || params[:country].present?
  end

  def search_query
    @search ||= Search.new(params.permit!.to_h)
  end

  def set_layout
    if request.headers['X-AJAX']
      false
    else
      "application"
    end
  end

  def query_params
    { query: { as_of: search_query.date } }
  end

  def set_cache
    unless Rails.env.development?
      expires_in 2.hours, :public => true, 'stale-if-error' => 86400, 'stale-while-revalidate' => 86400
    end
  end

  protected

  def maintenance_mode_if_active
    if ENV["MAINTENANCE"].present? && action_name != "maintenance"
      redirect_to "/503"
    end
  end

  def bots_no_index_if_historical
    response.headers["X-Robots-Tag"] = "none" unless @search.today?
  end

  def append_info_to_payload(payload)
    super
    payload[:user_agent] = request.env["HTTP_USER_AGENT"]
  end
end
