module ServiceHelper
  def trade_tariff_heading
    t("trade_tariff_heading")[service_choice.to_sym]
  end

  # TODO: Remove the uk-old case when we switch to the new UK version
  def switch_service_link
    case service_choice
    when "uk-old" then link_to(t("trade_tariff_heading")[:xi], "/xi#{current_path}")
    when "uk" then link_to(t("trade_tariff_heading")[:xi], "/xi#{current_path}")
    else
      link_to(t("trade_tariff_heading")["uk-old".to_sym], current_path)
    end
  end

  def service_switch_banner(optional_classes: "govuk-!-margin-bottom-7")
    tag.div(class: "tariff-breadcrumbs js-tariff-breadcrumbs clt govuk-!-font-size-15 #{optional_classes}") do
      tag.nav do
        tag.p do
          banner_copy
        end
      end
    end
  end

private

  def service_choice
    TradeTariffFrontend::ServiceChooser.service_choice ||
      TradeTariffFrontend::ServiceChooser::SERVICE_DEFAULT
  end

  def banner_copy
    return t("service_banner.big.#{service_choice}", link: switch_service_link).html_safe if current_path == "/sections"

    t("service_banner.small", link: switch_service_link).html_safe
  end

  def current_path
    request.filtered_path.sub("/#{service_choice}", "")
  end
end
