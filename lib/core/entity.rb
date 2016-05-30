class Neon::Entity

  def initialize(distilled_hash)
    @neon_content = distilled_hash
    yield if block_given?
  end

  def [](key)
    @neon_content[key]
  end

  def method_missing(method_name)
    return @neon_content[method_name] if @neon_content.has_key? method_name
    super
  end

  class << self
    def inherited(subclass)
      subclass.instance_variable_set("@neon_entity_klass", subclass)
    end

    def search(key, operator, value, pagination_options = {})
      @neon_api ||= Neon::ApiInterface.new(search_options)
      build_entities(@neon_api.search(key, operator, value, pagination_options))
    end

    def build_entities(distilled_hash)
      if distilled_hash[:results]
        distilled_hash[:entities] = distilled_hash.delete(:results).map{|item| @neon_entity_klass.new(item)}
      end
      distilled_hash
    end

  protected
    def search_options
      raise NotImplementedError.new "A concrete class must implement a \"search_options\" method for this abstract class."
    end

    def output_fields
      raise NotImplementedError.new "A concrete class must implement an \"output_fields\" method for this abstract class."
    end

    def field_map
      nil
    end
  end

end

require 'entities/account'
require 'entities/event'
