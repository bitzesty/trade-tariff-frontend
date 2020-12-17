module ServiceHelper
  def trade_tariff_heading
    t('trade_tariff_heading')[service_choice.to_sym]
  end

  # TODO: Remove the uk-old case when we switch to the new UK version
  def switch_service_link
    current_path = request.filtered_path.sub("/#{service_choice}", '')

    case service_choice
    when 'uk-old' then link_to(t('trade_tariff_heading')[:xi], "/xi#{current_path}")
    when 'uk' then link_to(t('trade_tariff_heading')[:xi], "/xi#{current_path}")
    else
      link_to(t('trade_tariff_heading')['uk-old'.to_sym], current_path)
    end
  end

  private

  def service_choice
    TradeTariffFrontend::ServiceChooser.service_choice ||
      TradeTariffFrontend::ServiceChooser::SERVICE_DEFAULT
  end
end
