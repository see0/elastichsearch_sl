module ElasticsearchSl
  module Filters
    class OrFilter
      attr_reader :data


      def initialize(data= nil, options={}, &block)
        @data = data
        @options = options
        @value   = {}
        block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
      end

      def filter(&block)
        (@value[:or] ||= []) << Filter.new(@data, &block).to_hash
        @value
      end

      def method_missing(method_name, *args, &block)
        (@value[:and] ||= []) << Filter.new(@data, &block).send(method_name.to_sym, *args).to_hash
        @value
      rescue
        super
      end

      def to_hash
        @value.update(@options)
      end

      def to_json(options={})
        to_hash.to_json
      end

    end
  end
end