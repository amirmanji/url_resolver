require 'spec_helper'

describe UrlResolver::CacheImplementations::NilClassCache do
  subject { UrlResolver::Cache.new(nil) }
  
  it 'does nothing for #set_url and #get_url requests' do
    subject.set_url('key', 'value').should be_nil
    subject.get_url('key').should be_nil
  end

end
