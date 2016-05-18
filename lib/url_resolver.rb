require 'rest-client'

require_relative 'url_resolver/cache.rb'
require_relative 'url_resolver/cache_implementations.rb'
require_relative 'url_resolver/configuration.rb'
require_relative 'url_resolver/errors.rb'
require_relative 'url_resolver/resolver.rb'

module UrlResolver
  def self.resolve(url)
    @@resolver ||= UrlResolver::Resolver.new
    @@resolver.resolve(url)
  end
end
