Rack::Attack.blocklist('block access if locked and ip is not listed') do |request|
  TradeTariffFrontend::Locking.locked? && !TradeTariffFrontend::Locking.allowed_ip(request.ip)
end