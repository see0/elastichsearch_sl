module ElasticsearchSl
  module Queries
    class Query
      attr_accessor :value
      attr_reader :data

      def initialize(data = nil , &block)
        @data = data
        @value = {}
        block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block_given?
      end

      def match(field, value, options = {})
        query_options = {:query => value}.merge(options)
        @value[:match] = {field => query_options}
        @value
      end

      def match_phrase(field, value, options={})
        query_options = {:query => value}.merge(options)
        @value[:match_phrase] = {field => query_options}
        @value
      end

      def match_phrase_prefix(field, value, options={})
        query_options = {:query => value}.merge(options)
        @value[:match_phrase_prefix] = {field => query_options}
        @value
      end

      def multi_match(query, field=[], options={})
        @value[:multi_match] =  {query: query, fields: Array(field)}.merge(options)
        @value
      end

      def boolean(options={}, &block)
        @boolean ||= ElasticsearchSl::Shared::Boolean.new(ElasticsearchSl::Queries::Query, @data, options)
        block.arity < 1 ? @boolean.instance_eval(&block) : block.call(@boolean) if block_given?
        @value[:bool] = @boolean.to_hash
        @value
      end

      def boosting(options={}, &block)
        @boosting ||= BoostingQuery.new(@data, options)
        block.arity < 1 ? @boosting.instance_eval(&block) : block.call(@boosting) if block_given?
        @value[:boosting] = @boosting.to_hash
        @value
      end

      def common(field, query, options={})
        @value[:common] = {field => {query: query}.merge(options)}
        @value
      end

      def constant_score(&block)
        @value.update({:constant_score => ConstantScoreQuery.new(@data, &block).to_hash}) if block_given?
      end

      def dis_max(options={}, &block)
        @dis_max ||= DisMaxQuery.new(@data, options)
        block.arity < 1 ? @dis_max.instance_eval(&block) : block.call(@dis_max) if block_given?
        @value[:dis_max] = @dis_max.to_hash
        @value
      end

      def filtered(&block)
        @filtered = FilteredQuery.new(@data)
        block.arity < 1 ? @filtered.instance_eval(&block) : block.call(@filtered) if block_given?
        @value[:filtered] = @filtered.to_hash
        @value
      end

      #TODO: Fuzzy like this query

      def fuzzy_like_this_field(field, options={})
        query = {field => options}
        @value = {:fuzzy_like_this_field => query}
      end

      def function_score(&block)
        @fs = FunctionScoreQuery.new(@data)
        block.arity < 1 ?  @fs.instance_eval(&block) : block.call(@fs) if block_given?
        @value[:function_score] = @fs.to_hash
        @value
      end

      def fuzzy(field, value, options={})
        query = {field => {:value => value}.update(options)}
        @value = {:fuzzy => query}
      end

      #TODO: geoshape query
      #TODO: has child query
      #TODO: has parent query

      def ids(values, type=nil)
        @value = {:ids => {:values => Array(values)}}
        @value[:ids].update(:type => type) if type
        @value
      end

      #TODO: indices query

      def match_all(options = {})
        @value = {:match_all => options}
        @value
      end

      #TODO: more like this query
      #TODO: more like this field query

      def nested(options={}, &block)
        @nested = NestedQuery.new(@data, options)
        block.arity < 1 ? @nested.instance_eval(&block) : block.call(@nested) if block_given?
        @value[:nested] = @nested.to_hash
        @value
      end

      def prefix(field, value, options={})
        if options[:boost]
          @value = {:prefix => {field => {:value => value, :boost => options[:boost]}}}
        else
          @value = {:prefix => {field => value}}
        end
      end

      def query_string(value, options={})
        @value = {:query_string => {:query => value}.update(options)}
      end

      #TODO: simple query string

      def range(field, value)
        @value = {:range => {field => value}}
      end

      #TODO: regexp query
      #TODO: span first query
      #TODO: span multi term query
      #TODO: span near query
      #TODO: span not query
      #TODO: span or query
      #TODO: span term query

      def term(field, value, options={})
        query = {field => {:value => value}.update(options)}
        @value = {:term => query}
      end

      def terms(field, value, options={})
        @value = {:terms => {field => Array(value)}}
        @value[:terms].update(options)
        @value
      end

      #TODO: top children query
      #TODO: wildcard query
      #TODO: minimum should match
      #TODO: multi term query rewrite
      #TODO: template query

      def to_hash
        @value
      end

      def to_json(options={})
        to_hash.to_json
      end

    end

  end
end
