class Neon::Event < Neon::Entity

  def initialize(distilled_hash = {})
    super do
      @neon_content[:name] = @neon_content.delete(:event_name)

      @neon_content[:start_at] = nil
      @neon_content[:start_at] = DateTime.parse(@neon_content.delete(:event_start_date)) if @neon_content.has_key? :event_start_date

      @neon_content[:end_at] = nil
      @neon_content[:end_at] = DateTime.parse(@neon_content.delete(:event_end_date)) if @neon_content.has_key? :event_end_date
    end
  end

  def date
    @neon_content[:start_at]
  end

  class << self
    def search_options
      options = {}
      options[:operation] = '/event/listEvents'
      options[:response_key] = :listEvents
      options[:output_fields] = [:event_name, :event_start_date, :event_end_date]
      #    OUTPUT_FIELDS = [:event_id, :event_name, :event_start_date, :event_end_date, :registration_attendee_count]

      options
    end
  end
end
