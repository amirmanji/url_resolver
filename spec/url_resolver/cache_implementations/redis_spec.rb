require 'spec_helper'

describe UrlResolver::CacheImplementations::RedisCache do
  subject { UrlResolver::Cache.new(Redis.new) }
  
  describe '#set_url' do
    it 'calls #setex on the Redis instance with (key, ttl, value)' do
      Redis.any_instance.should_receive(:setex).with('key', 5, 'value')
      subject.set_url('key', 'value', 5)
    end
  end
  
  describe '#get_url' do
    it 'calls #get on the Redis instance with (key)' do
      Redis.any_instance.should_receive(:get).with('key')
      subject.get_url('key')
    end
    
    it 'returns the value stored in the Redis instance' do
      Redis.any_instance.stub(:get).and_return('secret')
      subject.get_url('key').should eq('secret')
    end
  end

end
