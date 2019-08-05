module Models
  module Changeable
    extend ActiveSupport::Concern

    def changes(query_params = {})
      retries = 0
      begin
        body = self.class.get("#{resource_path}/changes", query_params).body
        data = TariffJsonapiParser.new(body).parse
        data.map do |change_data|
          Change.new(change_data)
        end
      rescue StandardError
        if retries < Rails.configuration.x.http.max_retry
          retries += 1
          retry
        else
          raise
        end
      end
    end
  end
end
