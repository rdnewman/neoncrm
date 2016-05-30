# neoncrm

To work with Neon CRM API: https://developer.neoncrm.com/api/


THIS GEM IS STILL BEING DEVELOPED and may have severe issues.  As of this writing,
this gem only handles reading information from the API and so should not be able
to affect the data stored on Neon's servers.

You are welcome to contribute to this code base.  The LGPL license is just to prevent it
from being re-sold for profit.  If you fork it however for a separate implementation, LGPL might
limit your rights in distributing, so let me know if that's a problem.

To build the gem:  `gem build neoncrm.gemspec`
(As soon as it's ready for more general use, I'll post to RubyGems.org)

**Table of contents**
* [Installation](#Installation)
* [Use](#Use)
  * [simple customization](*simple-customization)
  * [advanced customization](*advanced-customization)
* [Provided classes](#provided-classes)
  * [Neon::Account](#neonaccount)
  * [Neon::Event](#neonevent)
* [Provided logical operators](#provided-logical-operators)



## Installation

Install the gem in the usual way, either with the `gem install` command or via Bundler.

To use the gem, two environment variables must be set:
* `NEON_API_KEY`:  get this from your Neon account.
* `NEON_ORG_ID`: this is your organization short name provided from Neon and used for all your Neon page access

As of this writing, two classes are especially relevant to the code using this gem:
* `Neon::Account`:  retrieves account information
* `Neon::Event`: retrieves event information

## Use
In general, you write your application classes as subclasses to the ones provided, such as

```ruby
class MyAccountClass < Neon::Account
  # ...
  # your code and supported customizations
  # ...
end
```

Once your class is subclassed from the provided Neon class then you retrieve records from your Neon account via `search`, such as

```ruby
result = MyAccountClass.search(:account_id, :equals, 5)
```

`search` requires three arguments: a field_key (e.g., `:account_id`), a logical operator (.e.g, `:equals`), and a search value (e.g., `5`).  `search` returns a Hash that contains some meta data and an Array of entities that can then be worked with.  For instance, in the above example, `result[:entities]` is an Array of `MyAccountClass` objects, so `result[:entities].first` is a `MyAccountClass` object and its fields are available as attributes of the object.

The provided `Neon::` classes can infer the fields to read from the provided field key.  The inference is simply the a conversation of the given symbol to a String where the words are capitalized and underscores replaced with spaces.  For instance, `:account_id` would be inferred by default to `Account Id` and `:first_name` would be inferred by default to `First Name` when the request is made to Neon's server.

Please read the details below to make use of these classes.

#### Simple customization
There are three _class_ methods that may be overridden in your subclasses to tailor how fields are read from Neon:
* `field_map`: a Hash of Symbol keys to String values, where the Strings correspond to the field names provided by Neon for your site.
* `output_fields`: an Array of Symbols referring to the fields which are to be returned from Neon
* `search_options`: an advanced customization that can tailor the basic invocation of `search`

Often you'll override `field_map` and `output_fields`, but `search_options` will generally not require any customization.

**Example** of `field_map` for `MyAccountClass` (from above):

```ruby
def self.field_map
  {account_id: 'Account ID',
   email: 'Email 1',
   email1: 'Email 1',   # refers to same field as `:email`!
   email2: 'Email 2',
   email3: 'Email 3',
  }
end
```

Note that convenience aliases can be introduced, as for `email` and `email1` in the above example.   For `:account_id` of an Account, Neon normally uses "Account ID" as its field name, so we must alias `:account_id` to avoid the default inference of "Account Id".

**Example** of `field_map` for `MyAccountClass` (from above):

```ruby
def self.output_fields
  [:account_id, :first_name, :last_name, :email1, :email2, :email3]
end
```

Each provided `Neon::` class has a default set of `output_fields` already defined.  These are described under "Provided Classes" below.

Note that these symbols must either be explicitly specified in the `field_map` or they will be inferred from the symbol itself.

#### Advanced customization
As of this writing, this gem only supports the read-only portion of the Neon API.  However, additional entities for reading can be created beyond those of the provided classes (below). This is accomplished by writing a new class that inherits from Neon::Entity and implements both the `search_options` and `output_fields` methods.  For instance, this is the current implementation of the provided Neon::Account class:

```ruby
class Neon::Account < Neon::Entity

  class << self
    def search_options
      options = {}
      options[:operation] = '/account/listAccounts'    # as specified by Neon in its documentation
      options[:response_key] = :listAccountsResponse   # corresponds to the JSON key used by Neon in its results (see Neon documentation)
      options[:output_fields] = output_fields          # uses the class method "output_fields" below to get its Array
      options[:field_map] = field_map                  # uses the class method "field_map" below to get its Hash
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
```

## Provided classes
Each of the provided classes offer minimal defaults so they can work immediately for most sites.

#### Neon::Account
This superclass retrieves account information and supports this Neon API request: <a href='https://developer.neoncrm.com/api/accounts/searching-for-accounts/list-accounts/', target='_blank'>https://developer.neoncrm.com/api/accounts/searching-for-accounts/list-accounts/</a>

**Defaults**:

```ruby
def self.field_map
  {account_id: 'Account ID'}
end

def self.output_fields
  [:account_id, :first_name, :last_name]
end
```

#### Neon::Event
This superclass retrieves event information and supports this Neon API request: <a href='https://developer.neoncrm.com/api/events/list-events/', target='_blank'>https://developer.neoncrm.com/api/events/list-events/</a>

**Defaults**:

```ruby
def self.field_map
  nil    # nil causes all Neon field names to be inferred from the symbols used
end

def self.output_fields
  [:event_name, :event_start_date, :event_end_date]
end
```

## Provided logical operators
The following are the provided symbols for specifying the operators that Neon expects (note that convenience aliases are offered for readablity).  Please see the Neon API documentation for understanding how Neon interprets these strings.

| Available symbol(s) | Neon string |
|---------------------|:------------|
| `:equal`, `:equals` | "EQUAL" |
| `:not_equal`, `:not_equals` | "NOT_EQUAL" |
| `:blank`, `:empty` | "BLANK" |
| `:not_blank`, `:present` | "NOT_BLANK" |
| `:less_than` | "LESS_THAN" |
| `:less_and_equal`, `:less_than_or_equal` | "LESS_AND_EQUAL" |
| `:greater_than` | "GREATER_THAN" |
| `:greater_and_equal`, `:greater_than_or_equal` | "GREATER_AND_EQUAL" |
| `:contain`, `:contains` | "CONTAIN" |
