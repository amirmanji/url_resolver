module UrlResolver
  module CacheImplementations
    module NilClassCache
      def set_url(url, destination, ttl = 0)
        nil
      end
    
      def get_url(url)
        nil
      end
    end
  end
end
