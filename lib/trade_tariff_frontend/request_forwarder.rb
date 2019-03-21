require 'uri'
require 'net/http'

module TradeTariffFrontend
  class RequestForwarder
    IGNORED_UPSTREAM_HEADERS = %w[status x-ua-compatible connection transfer-encoding].freeze

    def initialize(opts = {})
      @host = URI.parse(opts.fetch(:host))
      @api_request_path_formatter = opts.fetch(:api_request_path_formatter) do
        ->(path) { path }
      end
    end

    def call(env)
      rackreq = Rack::Request.new(env)

      case rackreq.request_method
      # The API is read-only
      when "GET", "HEAD"
        response = HTTParty.send(
          rackreq.request_method.downcase, 
          request_url_for(rackreq), 
          {
            timeout: Integer(ENV.fetch('HTTPARTY_READ_TIMEOUT', 661)), 
            headers: request_headers_for(env)
          }
        )

        Rack::Response.new(
          [response.body],
          response.code.to_i,
          Rack::Utils::HeaderHash.new(
            response.headers.
                     except(*IGNORED_UPSTREAM_HEADERS).
                     merge('X-Slimmer-Skip' => true).
                     merge('Cache-Control' => "max-age=#{cache_max_age}")
          )
        ).finish
      else
        # "DELETE", "OPTIONS", "TRACE" "PUT", "POST"
        #
        # 405 METHOD NOT ALLOWED

        Rack::Response.new([], 405, {})
      end
    end

    private

    def request_url_for(rackreq)
      "#{@host}#{request_uri_for(rackreq)}"
    end

    def request_uri_for(rackreq)
      api_request_path_for(rackreq.env["PATH_INFO"] + "?" + rackreq.env["QUERY_STRING"])
    end

    def request_headers_for(env)
      headers = Rack::Utils::HeaderHash.new

      env.each { |key, value|
        if key =~ /HTTP_(.*)/
          headers[$1] = value unless ["HTTP_VERSION", "HTTP_CACHE_CONTROL"].include?(key)
        end
      }
      headers
    end
    
    def api_request_path_for(path)
      @api_request_path_formatter.call(path)
    end

    def cache_max_age(now=nil)
      now ||= Time.now.utc
      case now.hour
      when 0..21
        now.change(hour: 22).to_i - now.to_i
      when 22
        now.change(hour: 23).to_i - now.to_i
      when 23
        now.tomorrow.change(hour: 22).to_i - now.to_i
      end
    end
  end
end
