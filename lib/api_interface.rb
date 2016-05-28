module Neon
  class ApiInterface
    def initialize(options)
      @fields = options[:fields] || {}
      @operation = options[:operation] || ''
      @output_fields = options[:output_fields] || []
      @response_key = options[:response_key] || Symbol.new

      @query = Neon::InternalQueryEngine.new(@fields)
    end

    def search(key, operator, value, pagination_options)
      params = ''
      params << @query.outputfields_clause(@output_fields)
      params << @query.search_clause(key, operator, value)
      params << @query.pagination_clause(pagination_options)

      raw_response = @query.api_request(@operation, params)
      response = JSON.parse(raw_response.body).with_indifferent_access[@response_key]

      result = response[:operationResult]
      unless result == "SUCCESS"
        Rails.logger.error "API request to Neon FAILED!  #{response}"
      end

      Neon::Distiller.distill(response)
    end
  end
end

require 'entity'
