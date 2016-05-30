class Neon::Account < Neon::Entity

  class << self
    def search_options
      options = {}
      options[:operation] = '/account/listAccounts'
      options[:response_key] = :listAccountsResponse
      options[:output_fields] = output_fields
      options[:field_map] = field_map
      options
    end

    def field_map
      {account_id: 'Account ID'}
    end

    def output_fields
      [:account_id, :first_name, :last_name]
    end
  end
end
