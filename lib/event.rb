class Neon::Event < Neon::Entity

  class << self
    def search_options
      options = {}
      options[:operation] = '/event/listEvents'
      options[:response_key] = :listEvents
      options[:output_fields] = output_fields
      options
    end

    def output_fields
      [:event_name, :event_start_date, :event_end_date]
    end
  end
end
