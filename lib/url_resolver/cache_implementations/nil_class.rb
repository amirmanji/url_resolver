module UrlResolver
  module CacheImplementations
    module NilClassCache
      def set(key, value, ttl = 24.hours)
        nil
      end
    
      def get(key)
        nil
      end
    end
  end
end
