require 'spec_helper'

describe ElasticsearchSl::Aggs::Agg do

  subject do
    ElasticsearchSl::Aggs::Agg
  end

  let(:with_para) do
    subject.new(bar: 'foobar')
  end

  context 'exists' do
    it 'generate correct es syntax' do
      result = with_para.instance_eval do
        b('cool') do
          terms data[:bar]
          aggs do
            stats data[:bar] , 'foo'
          end
        end

        b('bar 22') do
          terms data[:bar]
          aggs do
            stats data[:bar] , 'foo'
          end
        end

      end

      expect(result.to_hash).to eq({"cool"=>{:terms=>{:field=>"foobar"}, :aggs=>{"foobar"=>{:stats=>{:field=>"foo"}}}}, "bar 22"=>{:terms=>{:field=>"foobar"}, :aggs=>{"foobar"=>{:stats=>{:field=>"foo"}}}}})
    end
  end

end