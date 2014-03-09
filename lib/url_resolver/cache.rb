module UrlResolver
  class Cache
    def initialize(cache = nil)
      @cache = cache
  
      if cache.class.name == 'Redis'
        extend CacheImplementations::RedisCache
      elsif cache.class.name == 'NilClass'
        extend CacheImplementations::NilClassCache
      else
        raise ArgumentError.new("Invalid cache class: #{cache.class}")
      end
    end
  end
end
