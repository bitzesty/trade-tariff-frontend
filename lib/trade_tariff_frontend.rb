require 'trade_tariff_frontend/api_constraints'
require 'trade_tariff_frontend/request_forwarder'
require 'redis_resolver'

module TradeTariffFrontend
  autoload :Presenter,      'trade_tariff_frontend/presenter'
  autoload :ViewContext,    'trade_tariff_frontend/view_context'

  module_function

  # API Endpoints of the Tariff API app that can be reached
  # via Frontend
  def accessible_api_endpoints
    %w[sections chapters headings commodities updates monetary_exchange_rates]
  end

  def production?
    ENV["GOVUK_APP_DOMAIN"] == "tariff-frontend-production.cloudapps.digital"
  end

  def production_domain?(domain)
    domain == "www.trade-tariff.service.gov.uk"
  end

  def currency_picker_enabled?
    ENV["CURRENCY_PICKER"].to_i == 1
  end

  # Number of suggestions returned to select2
  def suggestions_count
    10
  end

  # Email of the user who receives all info/error notifications, feedback
  def from_email
    ENV["TARIFF_FROM_EMAIL"]
  end

  def to_email
    ENV["TARIFF_TO_EMAIL"]
  end

  def regulations_enabled?
    return true unless ENV['HIDE_REGULATIONS']

    ENV.fetch('HIDE_REGULATIONS') != 'true'
  end

  # CDS locking and authentication
  module Locking

    module_function

    def ip_locked?
      ENV['CDS_LOCKED_IP'].present? && ENV['CDS_IP_WHITELIST'].present?
    end

    def allowed_ip(ip)
      allowed_ips = ENV['CDS_IP_WHITELIST']&.split(',')&.map(&:squish) || []
      allowed_ips.include?(ip)
    end

    def auth_locked?
      ENV['CDS_LOCKED_AUTH'].present? && ENV['CDS_USER'].present? && ENV['CDS_PASSWORD'].present?
    end

    def user
      ENV['CDS_USER']
    end

    def password
      ENV['CDS_PASSWORD']
    end
  end
end
