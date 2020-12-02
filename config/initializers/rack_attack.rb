Rack::Attack.blocklist('block access if locked and ip is not listed') do |request|
  TradeTariffFrontend::Locking.ip_locked? && !TradeTariffFrontend::Locking.allowed_ip?(request.ip)
end

Rack::Attack.blocklist('block access for non AWS CDN requests') do |request|
  result = TradeTariffFrontend::Locking.cdn_locked? && !TradeTariffFrontend::Locking.cdn_request?(request.env['CDN_SECRET'])
  result = !TradeTariffFrontend::Locking.allowed_ip?(request.ip) if result && TradeTariffFrontend::Locking.has_ip_allow_list?
  result
end
