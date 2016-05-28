class Neon::Account < Neon::Entity

  class << self
    def search_options
      options = {}
      options[:operation] = '/account/listAccounts'
      options[:response_key] = :listAccountsResponse
      options[:output_fields] = output_fields
      options
    end

    def output_fields
      [:first_name, :last_name]
    end
  end
end
