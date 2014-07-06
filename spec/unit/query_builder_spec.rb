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

      filter do
        term 'love', data[:first_name][0]
      end

      aggs do
        b 'cool' do
          terms 'lobe' 'cool'
        end
      end

      sort { by :title, 'desc'; by :cool, 'desc' }
      from 12
      size 100

    end

    expect(result.to_hash).to eq({:sort=>[{:title=>"desc"}, {:cool=>"desc"}], :from=>12, :size=>100, :query=>{:bool=>{:should=>[{:match=>{:first_name=>{:query=>"honda"}}}, {:match=>{:first_name=>{:query=>"honda2"}}}]}}, :aggs=>{"cool"=>{:terms=>{:field=>"lobecool"}}}, :filter=>{:term=>{"love"=>"honda"}}})
  end

end