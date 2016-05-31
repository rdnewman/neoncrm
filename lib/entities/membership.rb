class Neon::Membership < Neon::Entity

  class << self
    def search_options
      options = {}
      options[:operation] = '/membership/listMemberships'
      options[:field_map] = field_map
      options[:response_key] = :listMembershipsResponse
      options[:output_fields] = output_fields
      options
    end

    def field_map
      {account_id: 'Account ID'}
    end

    def output_fields
      [:account_id, :membership_name, :membership_cost]
    end
  end
end
