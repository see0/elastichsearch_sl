require 'spec_helper'

describe 'QueryBuilder Sanity Test' do

  it 'can accept external data' do
    result = ElasticsearchSl::QueryBuilder.new(data: {first_name: ['honda', 'honda2'] }) do
      query do
        boolean do
          should { match :first_name, data[:first_name][0] }
          should { match :first_name, data[:first_name][1] }
        end
      end
    end

    expect(result.to_hash).to eq({query: {bool:{ should: [ {match:{first_name: {query: 'honda'}}} , {match:{first_name: {query: 'honda2'}}}] }}})
  end

  #
  # it 'test' do
  #   query do
  #     function_score do
  #
  #       filter/query do
  #
  #       end
  #
  #       function do
  #         filter
  #         script_score/boost_factor/gauss/exp/linear
  #       end
  #
  #       function do
  #         filter {
  #         }
  #         script_score/boost_factor/gauss/exp/linear
  #       end
  #
  #       max_boost
  #       score_mode
  #       boost 2
  #       boost_mode 'awa'
  #     end
  #   end
  # end


end