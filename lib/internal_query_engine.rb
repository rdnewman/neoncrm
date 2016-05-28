module Neon
  class InternalQueryEngine
    def initialize(fields)
      @fields = fields
    end

    def api_request(operation, params = nil)
      url = self.send(:url, operation, params)
      Rails.logger.info "[Neon::Query] API request: \"#{url}\""
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.request(Net::HTTP::Get.new(url.request_uri))
    end

    def outputfields_clause(key_array)
      key_array.map do |key|
        "&outputfields.idnamepair.id=&outputfields.idnamepair.name=#{field(key)}"
      end.join('')
    end

    def search_clause(key, operator, value)
      parts = ''
      parts << "&searches.search.key=#{field(key)}"
      parts << "&searches.search.searchOperator=#{operators[operator]}"
      parts << "&searches.search.value=#{value}"
    end

    def pagination_clause(options = {})
      parts = ''
      parts << "&page.currentPage=#{options[:page] ? options[:page].to_s : '1'}"

      if options[:page_size]
        if options[:page_size] == :max
          parts << "&page.pageSize=999999"
        else
          parts << "&page.pageSize=#{options[:page_size].to_s}"
        end
      else
        parts << "&page.pageSize=10"
      end

      parts << "&page.sortColumn=#{field(options[:sort_by])}" if options[:sort_by]

      parts << "&page.sortDirection=#{options[:direction] ? options[:direction].to_s.upcase : 'ASC'}"
    end

  private
    def url(operation, params = nil)
      if session_key
        URI.parse("#{Neon::Crm::base_url}#{operation}?responseType=json&userSessionId=#{session_key}#{params ? params : ''}")
      else
        raise 'Unable to establish session key for Neon CRM API request.'
      end
    end

    def field(key)
      @fields[key] || key.to_s.gsub(/_/, ' ').split(/(\W)/).map(&:capitalize).join
    end

    def session_key
      @@neon_session_key ||= Neon::Crm::request_session_key
    end

    def operators
      {equal: 'EQUAL',
       equals: 'EQUAL',

       not_equal: 'NOT_EQUAL',
       not_equals: 'NOT_EQUAL',

       empty: 'BLANK',
       blank: 'BLANK',

       not_blank: 'NOT_BLANK',
       present: 'NOT_BLANK',

       less_than: 'LESS_THAN',

       less_and_equal: 'LESS_AND_EQUAL',
       less_than_or_equal: 'LESS_AND_EQUAL',

       greater_than: 'GREATER_THAN',

       greater_and_equal: 'GREATER_AND_EQUAL',
       greater_than_or_equal: 'GREATER_AND_EQUAL',

       contains: 'CONTAIN',
       contain: 'CONTAIN'
      }
    end
  end
end
