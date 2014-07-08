module ElasticsearchSl
  module Queries
    class ConstantScoreQuery

      attr_reader :data


      def initialize(data =nil, &block)
        @data = data
        @value = {}
        block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
      end

      def filter(&block)
        @value[:filter] = ElasticsearchSl::Filters::Filter.new(@data, &block).to_hash
        @value
      end

      def query(&block)
        @value.update(:query => Query.new(@data, &block).to_hash)
      end

      def boost(boost)
        @value.update(:boost => boost)
      end

      def to_hash
        @value
      end
    end

  end
end