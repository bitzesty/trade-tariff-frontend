require 'trade_tariff_frontend'

module RoutingFilter
  class ServicePathPrefixHandler < Filter
    SERVICE_CHOICE_PATH_PREFIXES = ::TradeTariffFrontend::ServiceChooser.service_choices.each_with_object({}) do |(key, value), acc|
      acc["/#{key}"] = key
    end.freeze

    # Recognising paths
    def around_recognize(path, env)
      prefix, choice = SERVICE_CHOICE_PATH_PREFIXES.find { |prefix, choice| path.start_with?(prefix) }
      default = ::TradeTariffFrontend::ServiceChooser.service_default

      path.sub!(prefix, "") if prefix

      if choice.present? && choice != default
        ::TradeTariffFrontend::ServiceChooser.service_choice = choice

        yield.tap do |params|
          params[:service_api_choice] = choice
        end
      else
        yield
      end
    end

    # Rendering links
    def around_generate(params, &block)
      yield.tap do |path, params|
        choice = ::TradeTariffFrontend::ServiceChooser.service_choice
        default = ::TradeTariffFrontend::ServiceChooser.service_default

        prepend_segment!(path, choice) if choice && choice != default
      end
    end
  end
end
