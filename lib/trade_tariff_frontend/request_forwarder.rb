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
        api_version = rackreq.path
                             .downcase
                             .split('/')
                             .reject { |p| p.empty? || p == 'api' }
                             .first || "v#{Rails.configuration.x.backend.api_version}"
        conn = Faraday.new
        response = conn.send(
          rackreq.request_method.downcase,
          request_url_for(rackreq)
        ) do |req|
          req.headers['Accept'] = "application/vnd.uktt.#{api_version}"
          req.headers['Content-Type'] = env['CONTENT_TYPE']
          req.options.timeout = 60           # open/read timeout in seconds
          req.options.open_timeout = 15      # connection open timeout in seconds
        end

        Rack::Response.new(
          [response.body],
          response.status.to_i,
          Rack::Utils::HeaderHash.new(
            response.headers.
                     except(*IGNORED_UPSTREAM_HEADERS).
                     merge('X-Slimmer-Skip' => true).
                     merge('Cache-Control' => cache_control_string(response))
          )
        ).finish
      else
        # "DELETE", "OPTIONS", "TRACE" "PUT", "POST"
        #
        # 405 METHOD NOT ALLOWED

        Rack::Response.new([], 405, {}).finish
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
          headers[$1] = value
        end
      }
    end

    def api_request_path_for(path)
      @uri = URI.parse(path)
      @api_request_path_formatter.call(path)
    end

    def cache_control_string(response)
      return 'no-cache'
    end
  end
end
