Gem::Specification.new do |s|
  s.name        = 'url_resolver'
  s.version     = '0.1.0'
  s.date        = '2014-03-08'
  s.summary     = "Url Resolver"
  s.description = "Follows redirects to resolve the destination of a URL"
  s.authors     = ["Amir Manji"]
  s.email       = 'amanji75@gmail.com'
  s.files       = ["lib/url_resolver.rb"]
  s.homepage    =
    'http://www.github.com/amirmanji/url_resolver'
  s.license       = 'MIT'
  s.add_runtime_dependency "rest-client", [ ">= 1.6.7" ]
end
