module UrlResolver
  module CacheImplementations
    module RedisCache
      def set(key, value, ttl = 24.hours)
        @cache.setex(key, value, ttl)
      end
    
      def get(key)
        @cache.get(key)
      end
    end
  end
end
