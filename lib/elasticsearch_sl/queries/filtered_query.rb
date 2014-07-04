module ElasticsearchSl
  module Queries
    class FilteredQuery

      attr_reader :data


      def initialize(data = nil, &block)
        @data = data
        @value = {}
        block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
      end

      def query(options={}, &block)
        @value[:query] = Query.new(@data, &block).to_hash
        @value
      end

      def filter(type, *options)
        @value[:filter] ||= {}
        @value[:filter][:and] ||= []
        @value[:filter][:and] << ElasticsearchSl::Filters::Filter.new(type, *options).to_hash
        @value
      end

      def to_hash
        @value
      end

      def to_json(options={})
        to_hash.to_json
      end
    end
  end
end