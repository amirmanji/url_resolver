require_relative './lib/url_resolver/version'

Gem::Specification.new do |s|
  s.name        = 'url_resolver'
  s.version     = UrlResolver::VERSION
  s.date        = '2016-05-18'
  s.summary     = "Url Resolver!"
  s.description = "Simple gem to follow redirects to resolve the destination of a URL. Caches results sometimes."
  s.authors     = ["Amir Manji"]
  s.email       = 'amanji75@gmail.com'
  s.files       =  Dir.glob("{bin,lib}/**/*")
  s.homepage    =
    'http://www.github.com/amirmanji/url_resolver'
  s.license       = 'MIT'
  s.add_runtime_dependency "rest-client", '~> 2.0.2'
  s.add_development_dependency "rspec", '~> 3.8'
  s.add_development_dependency "simplecov", '~> 0.16'
  s.add_development_dependency "webmock", '~> 3.5'
end
