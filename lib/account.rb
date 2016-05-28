class Neon::Account < Neon::Entity

  def initialize(distilled_hash = {})
    super do
      @neon_content[:id] = nil
      @neon_content[:id] = @neon_content.delete(:account_id).to_i if @neon_content.has_key? :account_id
    end
  end

  def name
    name = [@neon_content[:first_name], @neon_content[:last_name]].join(' ').strip
    name.empty? ? nil : name
  end

  def primary_email
    @neon_content[:email].first
  end

  class << self
    def search_options
      options = {}
      options[:operation] = '/account/listAccounts'
      options[:response_key] = :listAccountsResponse
      options[:fields] = aliased_field_symbols
      options[:output_fields] = [:account_id, :first_name, :last_name, :email]
      options
    end

    def aliased_field_symbols
      {account_id: 'Account ID',
       email: 'Email 1',
       email1: 'Email 1',
       email2: 'Email 2',
       email3: 'Email 3',
      }
    end
  end
end
