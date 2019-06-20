require 'spec_helper'

describe UrlResolver::CacheImplementations::NilClassCache do
  subject { UrlResolver::Cache.new(nil) }
  
  it 'does nothing for #set_url and #get_url requests' do
    expect(subject.set_url('key', 'value')).to be_nil
    expect(subject.get_url('key')).to be_nil
  end

end
