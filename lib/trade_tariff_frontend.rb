require 'trade_tariff_frontend/api_constraints'
require 'trade_tariff_frontend/request_forwarder'
require 'paas_config'

module TradeTariffFrontend
  autoload :Presenter,      'trade_tariff_frontend/presenter'
  autoload :ViewContext,    'trade_tariff_frontend/view_context'

  module_function

  # API Endpoints of the Tariff Backend API app that can be reached via Frontend
  def accessible_api_endpoints
    %w[sections chapters headings commodities updates monetary_exchange_rates quotas
       goods_nomenclatures search_references geographical_areas]
  end

  # API Endpoints of the Tariff Backend API app that can be reached via external client
  def public_api_endpoints
    %w[sections chapters headings commodities monetary_exchange_rates quotas goods_nomenclatures
       search_references additional_codes certificates footnotes geographical_areas chemicals
       additional_code_types certificate_types footnote_types]
  end

  def production?
    ENV["GOVUK_APP_DOMAIN"] == "tariff-frontend-production.london.cloudapps.digital"
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

  def origin
    regulations_enabled? ? "EU" : "UK"
  end

  def robots_enabled?
    ENV.fetch('ROBOTS_ENABLED', 'false') == 'true'
  end

  def currency_picker_enabled?
    ENV["CURRENCY_PICKER"].to_i == 1
  end

  def regulations_enabled?
    return true unless ENV['HIDE_REGULATIONS']

    ENV.fetch('HIDE_REGULATIONS') != 'true'
  end

  def block_searching_past_march?
    return true unless ENV['ALLOW_SEARCH']

    ENV.fetch('ALLOW_SEARCH') != 'true'
  end

  def download_pdf_enabled?
    ENV.fetch('DOWNLOAD_PDF_ENABLED', 'false') == 'true'
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

  class BasicAuth < Rack::Auth::Basic
    def call(env)
      if TradeTariffFrontend::Locking.auth_locked?
        super # perform auth
      else
        @app.call(env) # skip auth
      end
    end
  end
end
