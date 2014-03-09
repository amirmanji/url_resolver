module UrlResolver
  module CacheImplementations
    module RedisCache
      def set_url(url, destination, ttl = 86400)
        @cache.setex(url, ttl, destination)
      end
    
      def get_url(url)
        @cache.get(url)
      end
      
      def cache_key(url)
        "url_resolver.urls.#{url}"
      end
    end
  end
end
