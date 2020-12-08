require 'trade_tariff_frontend'

module RoutingFilter
  class ServicePathPrefixHandler < Filter
    SERVICE_CHOICE_PATH_PREFIXES = ::TradeTariffFrontend::ServiceChooser.service_choices.each_with_object({}) do |(key, value), acc|
      acc["/#{key}"] = key
    end.freeze

    # Recognising paths
    def around_recognize(path, env)
      prefix, service_choice = SERVICE_CHOICE_PATH_PREFIXES.find { |prefix, choice| path.start_with?(prefix) }
      service_choice_default = ::TradeTariffFrontend::ServiceChooser.service_default

      path.sub!(prefix, "") if prefix

      if service_choice.present? && service_choice != service_choice_default
        ::TradeTariffFrontend::ServiceChooser.service_choice = service_choice

        yield.tap do |params|
          params[:service_api_choice] = service_choice
        end
      else
        yield
      end
    end

    # Rendering links
    def around_generate(params, &block)
      yield.tap do |path, params|
        service_choice = ::TradeTariffFrontend::ServiceChooser.service_choice
        service_choice_default = ::TradeTariffFrontend::ServiceChooser.service_default

        prepend_segment!(path, service_choice) if service_choice && service_choice != service_choice_default
      end
    end
  end
end
