require File.expand_path("../lib/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name        = 'neoncrm'
  spec.version     = Neon::VERSION
  spec.date        = '2016-05-31'

  spec.required_ruby_version     = '>= 2.2.2'
  spec.required_rubygems_version = '>= 1.8.11'

  spec.summary     = "Ruby gem for Neon CRM API"
  spec.description = "Supplies classes that can request data from a Neon CRM site"
  spec.license     = 'LGPL-3.0'

  spec.authors     = ["Richard Newman"]
  spec.email       = 'richard@newmanworks.com'
  spec.homepage    = 'http://rubygems.org/gems/neoncrm'

  spec.files       = ["lib/neoncrm.rb"]

  spec.requirements << 'uses Net::HTTP Ruby module'
  spec.requirements << 'uses URI Ruby module'
end
