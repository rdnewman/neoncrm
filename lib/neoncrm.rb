require 'net/http'
require 'uri'
require 'core/crm'

# require all entity files
Dir[ File.join(File.dirname(__FILE__), 'entities/*.rb')].each { |file| require file }
