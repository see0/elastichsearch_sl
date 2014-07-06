#dependencies
require 'json'

#builders
require "elasticsearch_sl/query_builder"

#shared
require "elasticsearch_sl/shared/boolean"
require "elasticsearch_sl/shared/function"

#queries
require "elasticsearch_sl/queries/boosting_query"
require "elasticsearch_sl/queries/constant_score_query"
require "elasticsearch_sl/queries/dis_max_query"
require "elasticsearch_sl/queries/filtered_query"
require "elasticsearch_sl/queries/nested_query"
require "elasticsearch_sl/queries/function_score_query"

require "elasticsearch_sl/queries/query"

#filters
require "elasticsearch_sl/filters/and_filter"
require "elasticsearch_sl/filters/or_filter"
require "elasticsearch_sl/filters/filter"

#aggs
require "elasticsearch_sl/aggs/agg"

#version
require "elasticsearch_sl/version"

module ElasticsearchSl
  # Your code goes here...
end
