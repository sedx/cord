require 'faraday'
require 'json'
module Cord
  class Connection
    FAILURES = [400, 401, 404, 500].freeze

    attr_accessor :verb, :path, :params, :provider, :entity

    def initialize(entity, verb, path, params = {})
      @provider = entity.provider
      @verb = verb
      @path = path
      @params = params.merge(provider.permanent_params)
      @entity = entity
    end

    def process
      raise "Unknown HTTP verb #{verb}" unless known_verb?(verb) # TODO: EXCEPTION
      response = connection.send(verb) do |req|
        build_request(req, path, params)
      end
      if FAILURES.include? response.status
        raise Object.const_get("::#{provider}::#{entity}::Status#{response.status}"),
              response.body
      end
      hash = JSON.parse(response.body)
      entity.new hash
    end

    private

    def connection
      Faraday.new(url: prepare_path) do |faraday|
        faraday.request :url_encoded
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end
    end

    def prepare_path
      version_opts = provider.api_version
      return provider.api_host unless version_opts.version
      if version_opts.using == :path
        "#{provider.api_host}/#{version_opts.version}"
      end
    end

    def build_request(req, path, params)
      p params
      req.url path.to_s
      req.params = params unless params.empty?
    end

    def known_verb?(verb)
      [:get, :post, :put, :delete].include?(verb)
    end
  end
end
