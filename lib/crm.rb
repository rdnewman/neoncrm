module Neon
  class Crm
    NEON_API_KEY = ENV['NEON_API_KEY']
    NEON_ORG_ID = ENV['NEON_ORG_ID']

    class << self
      def base_url
        'https://api.neoncrm.com/neonws/services/api'
      end

      def request_session_key
        begin
          raise ArgumentError.new 'Must set NEON_API_KEY environment variable' unless NEON_API_KEY
          raise ArgumentError.new 'Must set NEON_ORG_ID environment variable' unless NEON_ORG_ID

          url = URI.parse("#{base_url}/common/login?login.apiKey=#{NEON_API_KEY}&login.orgid=#{NEON_ORG_ID}")
          Rails.logger.info "[Neon::Crm] session key requested: \"#{filter_url(url)}\"" if defined? Rails && defined? Rails.logger
          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true

          response = http.request(Net::HTTP::Get.new(url.request_uri))
          response_params = JSON.parse response.body
          response_params['loginResponse']['userSessionId']
        rescue StandardError => e
          Rails.logger.error "[Neon::Crm::request_session_key] error: #{e.inspect}" if defined? Rails && defined? Rails.logger
          nil
        end
      end

    private
      def filter_url(url)
        url.to_s.gsub(/.apiKey=.*&/, '.apiKey=[FILTERED]&')
      end
    end

  end
end

require 'internal_query_engine'
require 'distiller'
require 'api_interface'
