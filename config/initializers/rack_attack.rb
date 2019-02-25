locked = ENV['CDS_LOCKED'].present?
allowed_ips = ENV['CDS_IP_WHITELIST']&.split(',') || []

Rack::Attack.blocklist('12') do |request|
  locked && !allowed_ips.include?(request.ip)
end