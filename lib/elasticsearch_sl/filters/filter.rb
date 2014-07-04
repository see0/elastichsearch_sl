module ElasticsearchSl
  module Filters

    # http://www.elasticsearch.org/guide/reference/api/search/filter.html
    # http://www.elasticsearch.org/guide/reference/query-dsl/
    #
    class Filter

      def initialize(data, type, *options)
        value = if options.size < 2
          options.first || {}
        else
          options # An +or+ filter encodes multiple filters as an array
        end
        @hash = { type => value }
      end

      #create helper

      def boolean(options={}, &block)
        @boolean ||= ElasticsearchSl::Shared::Boolean.new(ElasticsearchSl::Queries::Filter, @data, options)
        block.arity < 1 ? @boolean.instance_eval(&block) : block.call(@boolean) if block_given?
        @hash[:bool] = @boolean.to_hash
        @hash
      end


      def to_json(options={})
        to_hash.to_json
      end

      def to_hash
        @hash
      end
    end

  end
end
