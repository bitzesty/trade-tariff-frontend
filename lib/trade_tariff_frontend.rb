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
    ['sections', 'chapters', 'headings', 'commodities', 'updates', "monetary_exchange_rates"]
  end

  def production?
    ENV["GOVUK_APP_DOMAIN"] == "tariff-frontend-production.cloudapps.digital"
  end

  def production_domain?(domain)
    domain == "www.trade-tariff.service.gov.uk"
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
end
