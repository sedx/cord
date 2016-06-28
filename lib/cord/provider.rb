module Cord
  class Provider
    class << self
      attr_accessor :api_host, :api_version, :api_format,
                    :permanent_params

      def host(host)
        self.api_host = host
      end

      def format(val)
        self.api_format = val
      end

      def api_format
        @api_format || :json
      end

      def params(hash)
        self.permanent_params = hash
      end

      def version(version, opts = {})
        if opts[:using] == :header && !opts.key?(:vendor)
          raise 'missing vendor' # TODO: EXCEPTION
        end
        self.api_version = Hashie::Mash.new do |h|
          h.version = version
          h.using = opts.fetch(:using, :path)
          h.vendor = opts.fetch(:vendor, nil)
        end
      end

      def tie(entity)
        entity.provider = self
        entity.instance_eval do
          ::Cord::Connection::FAILURES.each do |f|
            Object.const_set("Status#{f}", Class.new(StandardError))
          end
        end
        const_set(entity.to_s.match(/::(\w+\b)/)[1], entity)
      end
    end
  end
end
