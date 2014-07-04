require 'spec_helper'

describe ElasticsearchSl::Filters::Filter do

  subject do
    ElasticsearchSl::Filters::Filter
  end

  let(:with_para) do
    subject.new(bar: 'foobar')
  end

  context 'exists' do
    it 'generate correct es syntax' do
      result = with_para.instance_eval do
        exists 'cool'
      end

      expect(result.to_hash).to eq({:exists=>{:field=>"cool"}})
    end
  end

  context 'and' do

    it 'generate correct es syntax' do
      result = with_para.instance_eval do
        and_filter do
          filter { exists 'cool'}
        end
      end

      expect(result.to_hash).to eq(:and=>[{:exists=>{:field=>"cool"}}])
    end

  end
end