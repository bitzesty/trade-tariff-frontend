require 'faraday_middleware'
require 'multi_json'
require 'active_model'
require 'tariff_jsonapi_parser'

module ApiEntity
  class NotFound < StandardError; end
  class Error < StandardError; end

  extend ActiveSupport::Concern

  included do
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend  ActiveModel::Naming

    include Faraday
    include MultiJson

    attr_reader :attributes

    attr_accessor :casted_by

    class_eval do
      def resource_path
        "/#{self.class.name.underscore.pluralize}/#{to_param}"
      end

      def to_param
        id
      end
    end
  end

  def initialize(attributes = {})
    class_name = self.class.name.downcase

    if attributes.present? && attributes.has_key?(class_name)
      @attributes = attributes[class_name]

      self.attributes = attributes[class_name]
    else
      @attributes = attributes

      self.attributes = attributes
    end
  end

  def attributes=(attributes = {})
    if attributes.present?
      attributes.each do |name, value|
        if respond_to?(:"#{name}=")
          send(:"#{name}=", value.is_a?(String) && value == "null" ? nil : value)
        end
      end
    end
  end

  def persisted?
    true
  end

  module ClassMethods
    delegate :get, :post, to: :api

    def all(opts = {})
      collection(collection_path, opts)
    end

    def search(opts = {})
      collection("#{collection_path}/search", opts)
    end

    def collection(collection_path, opts = {})
      retries = 0
      begin
        resp = api.get(collection_path, opts)
        case resp.status
        when 404
          raise ApiEntity::NotFound, TariffJsonapiParser.new(resp.body).errors
        when 500
          raise ApiEntity::Error, TariffJsonapiParser.new(resp.body).errors
        when 502
          raise ApiEntity::Error, "502 Bad Gateway"
        end
        collection = TariffJsonapiParser.new(resp.body).parse
        collection = collection.map { |entry_data| new(entry_data) }
        collection = paginate_collection(collection, resp.body.dig('meta', 'pagination')) if resp.body.is_a?(Hash) && resp.body.dig('meta', 'pagination').present?
        collection
      rescue StandardError
        if retries < Rails.configuration.x.http.max_retry
          retries += 1
          retry
        else
          raise
        end
      end
    end

    def find(id, opts = {})
      retries = 0
      begin
        resp = api.get("/#{self.name.pluralize.parameterize}/#{id}", opts)
        case resp.status
        when 404
          raise ApiEntity::NotFound
        when 500
          raise ApiEntity::Error, TariffJsonapiParser.new(resp.body).errors
        when 502
          raise ApiEntity::Error, TariffJsonapiParser.new(resp.body).errors
        end
        resp = TariffJsonapiParser.new(resp.body).parse
        new(resp)
      rescue StandardError
        if retries < Rails.configuration.x.http.max_retry
          retries += 1
          retry
        else
          raise
        end
      end
    end

    def has_one(association, opts = {})
      options = opts.reverse_merge(class_name: association.to_s.singularize.classify)

      attr_accessor association.to_sym

      class_eval <<-METHODS
        def #{association}=(data)
          data ||= {}

          @#{association} ||= #{options[:class_name]}.new(data.merge(casted_by: self))
        end
      METHODS
    end

    def has_many(associations, opts = {})
      options = opts.reverse_merge(class_name: associations.to_s.singularize.classify, wrapper: Array)

      class_eval <<-METHODS
        def #{associations}
          #{options[:wrapper]}.new(@#{associations}.presence || [])
        end

        def #{associations}=(data)
          @#{associations} ||= if data.present?
            data.map { |record| #{options[:class_name]}.new(record.merge(casted_by: self)) }
          else
            []
          end
        end

        def add_#{associations.to_s.singularize}(record)
          @#{associations} ||= []
          @#{associations} << record
        end
      METHODS
    end

    def paginate_collection(collection, pagination)
      Kaminari.paginate_array(
        collection,
        total_count: pagination['total_count']
      ).page(pagination['page']).per(pagination['per_page'])
    end

    def collection_path(path = nil)
      if path
        @collection_path = path
      else
        @collection_path
      end
    end

    def api
      @api ||= Faraday.new Rails.application.config.api_host do |conn|
        conn.request :url_encoded
        conn.adapter Faraday.default_adapter
        conn.response :json, content_type: /\bjson$/
        conn.headers['Accept'] = "application/vnd.uktt.v#{Rails.configuration.x.backend.api_version}"
      end
    end
  end
end
