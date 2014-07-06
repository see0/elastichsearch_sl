module ElasticsearchSl
  module Shared
    class Function

      attr_reader :data

      def initialize(data= nil, options={}, &block)
        @data = data
        @options = options
        @value = {}
        block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
      end

      def filter(&block)
        @value[:filter] = ElasticsearchSl::Filters::Filter.new(@data, &block).to_hash
        @value
      end

      def script_score(options={})
        @value[:script_score] = options
        @value
      end

      def field_value_factor(options= {})
        @value[:field_value_factor] = options
        @value
      end

      def gauss(field, value = {}, options={})
        @value[:gauss] = {field => value}.update(options)
        @value
      end

      def random_score(number)
        @value[:random_score] = {seed: number }
        @value
      end

      def boost_factor(number)
        @value[:boost_factor] = number
        @value
      end

      def to_hash
        @value.update(@options)
      end

    end
  end
end