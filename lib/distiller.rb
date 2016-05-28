module Neon
  class Distiller

    class << self
      def distill(response)
        self.send(:distill_meta_data, response).merge(self.send(:distill_search_results, response))
      end

    private
      def distill_meta_data(raw_hash)
        result = {}
        result[:status] = distill_status_result(raw_hash)
        result[:response_at] = DateTime.parse(raw_hash[:responseDateTime])
        result.merge!(distill_errors(raw_hash))
        result.merge!(distill_page_details(raw_hash))
        result
      end

      def distill_search_results(raw_hash)
        return {} unless raw_hash[:searchResults] && raw_hash[:searchResults][:nameValuePairs]
        result = {}
        result[:results] = raw_hash[:searchResults][:nameValuePairs].map do |raw_record|
          record = {}
          raw_record[:nameValuePair].each do |pair|
            pair_value = pair[:value]
# to make generic as a gem, need to defer this to entity class processing
            pair_name = pair[:name].downcase.gsub(/ /, '_')
            if pair_name[0..4] == 'email'
              record[:email] ||= []
              record[:email][pair_name[6].to_i - 1] = pair_value
            else
              record[pair_name.to_sym] = pair_value
            end
          end
          record
        end
        result
      end

      def distill_status_result(raw_hash)
        status = {"SUCCESS" => :success, "FAIL" => :failed}
        status[raw_hash[:operationResult]]
      end

      def distill_page_details(raw_hash)
        return {} unless raw_hash[:page]
        raw = raw_hash[:page]
        {current_page: raw[:currentPage], count_per_page: raw[:pageSize], pages: raw[:totalPage], count: raw[:totalResults]}
      end

      def distill_errors(raw_hash)
        return {} unless raw_hash[:errors]
        raw = raw_hash[:errors]

        result = {}
        result[:errors] = raw[:error].map do |error|
          {code: error[:errorCode], message: error[:errorMessage]}
        end
        result[:error_page] = raw[:page] if raw[:page]
        result
      end
    end

  end
end
