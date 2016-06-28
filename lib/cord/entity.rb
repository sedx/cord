module Cord
  class Entity < ::Hashie::Mash
    class << self
      attr_accessor :provider, :namespaces

      def knot(meth, endpoint, **_opts, &blk)
        verb = endpoint.keys.first
        path = endpoint.values.first
        with_context(meth, blk) do
          define_singleton_method meth do |*args|
            if args.size != @context.params[meth].size
              raise ArgumentError,
                    "Expected #{@context.params[meth].size} arguments "\
                    "(#{@context.params[meth].join(', ')})"
            end
            params = Hash[@context.params[meth].zip args]
            ::Cord::Connection.new(self, verb, path, params).process
          end
        end
      end

      def params(*args)
        @context.params ||= {}
        @context.params[@knot] = args
      end

      private

      def with_context(knot, prepare_blk)
        @context ||= Struct.new('Context', :params, :schema).new
        @knot = knot
        prepare_blk.call
        yield
      end
    end
  end
end
