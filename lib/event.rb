class Neon::Event < Neon::Entity

  class << self
    def search_options
      options = {}
      options[:operation] = '/event/listEvents'
      options[:response_key] = :listEvents
      options[:output_fields] = output_fields
      options
    end
  end
end
