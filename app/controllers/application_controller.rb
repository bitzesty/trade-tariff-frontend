require "api_entity"

class ApplicationController < ActionController::Base
  protect_from_forgery
  include TradeTariffFrontend::ViewContext::Controller
  include ApplicationHelper

  # before_action :http_authentication, if: -> { TradeTariffFrontend::Locking.auth_locked? }
  before_action :set_last_updated
  before_action :set_cache
  before_action :preprocess_raw_params
  before_action :search_query
  before_action :set_currency_for_date
  before_action :maintenance_mode_if_active
  before_action :bots_no_index_if_historical

  layout :set_layout

  rescue_from Errno::ECONNREFUSED do |_e|
    render plain: '', status: :error
  end

  rescue_from ApiEntity::NotFound do
    render plain: '404', status: 404
  end

  rescue_from ApiEntity::Error, with: :render_500

  rescue_from URI::InvalidURIError do |_e|
    render plain: '404', status: 404
  end

  def url_options
    return super unless search_invoked?
    return { country: search_query.country, currency: search_query.currency }.merge(super) if search_query.date.today?

    {
      year: search_query.date.year,
      month: search_query.date.month,
      day: search_query.date.day,
      country: search_query.country,
      currency: search_query.currency
    }.merge(super)
  end

  private

  # def http_authentication
  #   if TradeTariffFrontend::Locking.auth_locked?
  #     authenticate_or_request_with_http_basic do |name, password|
  #       ActiveSupport::SecurityUtils.variable_size_secure_compare(name, TradeTariffFrontend::Locking.user) &
  #         ActiveSupport::SecurityUtils.variable_size_secure_compare(password, TradeTariffFrontend::Locking.password)
  #     end
  #   end
  # end

  def render_500
    render template: "errors/internal_server_error",
           layout: "pages",
           status: 500
    false
  end

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
    { as_of: search_query.date, currency: search_query.currency }
  end

  def set_cache
    unless Rails.env.development?
      expires_in 2.hours, :public => true, 'stale-if-error' => 86_400, 'stale-while-revalidate' => 86_400
    end
  end

  protected

  def preprocess_raw_params
    if TradeTariffFrontend.block_searching_past_march? && params[:year] && params[:month] && params[:day]
      search_date = Date.new(*[params[:year], params[:month], params[:day]].map(&:to_i))
      brexit_date = Date.parse(ENV['BREXIT_DATE'] || '19-5-22')
      now = Date.today
      if (search_date >= brexit_date) && (now < brexit_date)
        params[:year] = now.year
        params[:month] = now.month
        params[:day] = now.day
        flash[:alert] = "Sorry we are currently unable to display data past #{brexit_date.strftime("#{brexit_date.day.ordinalize} of %B %Y")}"
      end
    end
  end

  def set_currency_for_date
    search_query unless @search
    if search_date_in_future_month?
      @search.attributes[:currency] = "EUR"
      flash[:alert] = "Euro is the only currency supported for a search date in the future"
    end
  end

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
