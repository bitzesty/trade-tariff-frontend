require 'trade_tariff_frontend'

module RoutingFilter
  class ServicePathPrefixHandler < Filter
    SERVICE_CHOICE_PREFIXES =::TradeTariffFrontend::ServiceChooser.
      service_choices.
      keys.
      map { |prefix| Regexp.escape(prefix.to_s) }.
      join('|')

    SERVICE_CHOICE_PREFIXES_REGEX = %r{^/(#{SERVICE_CHOICE_PREFIXES})(?=/|$)}

    # Recognising paths
    def around_recognize(path, env)
      service_choice = extract_segment!(SERVICE_CHOICE_PREFIXES_REGEX , path)
      service_choice_default = ::TradeTariffFrontend::ServiceChooser.service_default

      if path != "/" && service_choice.present? && service_choice != service_choice_default
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
