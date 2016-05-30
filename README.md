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

## Installation

Install the gem in the usual way, either with the `gem install` command or via Bundler.

To use the gem, two environment variables must be set:
* `NEON_API_KEY`:  get this from your Neon account.
* `NEON_ORG_ID`: this is your organization short name provided from Neon and used for all your Neon page access

As of this writing, two classes are especially relevant to the code using this gem:
* `Neon::Account`:  retrieves account information
* `Neon::Event`: retrieves event information and supports this Neon API request: https://developer.neoncrm.com/api/events/list-events/

### Use
In general, you write your application classes as subclasses to the ones provided, such as

    class MyAccountClass < Neon::Account
    end

Once your class is subclassed from the provided Neon class then you retrieve records from your Neon account via `search`, such as

    result = MyAccountClass.search(:account_id, :equals, 5)

`search` requires three arguments (a field_key, a logical operator, and a search value) and returns a Hash that contains some meta data and an Array of entities that can then be worked with.  For instance, in the above example, `result[:entities]` is an Array of MyAccountClass objects, so `result[:entities].first` is a MyAccountClass object and it's fields are available as attributes of the object.

The provided `Neon::` classes can infer the fields to read from the provided field key.  The inference is simply the a conversation of the given symbol to a String where the words are capitalized and underscores replaced with spaces.  For instance, `:account_id` would be inferred by default to `Account Id` and `:first_name` would be inferred by default to `First Name` when the request is made to Neon's server.

Please read the details below to make use of these classes.

#### Customization
There are three methods that may be overridden in your subclasses to tailor how fields are read from Neon:
* `field_map`: a Hash of Symbol keys to String values, where the Strings correspond to the field names provided by Neon for your site.
* `output_fields`: an Array of Symbols referring to the fields which are to be returned from Neon
* `search_options`: an advanced customization that can tailor the basic invocation of `search`

Often you'll override `field_map` and `output_fields`, but `search_options` will generally not require any customization.

**Example** of `field_map` for `MyAccountClass` (from above):

    def field_map
      {account_id: 'Account ID',
       email: 'Email 1',
       email1: 'Email 1',
       email2: 'Email 2',
       email3: 'Email 3',
      }
    end

Note that convenience aliases can be introduced, as for `email` and `email1` in the above example.   For `:account_id` of an Account, Neon normally uses `Account ID` as it's field, so we must alias `:account_id` to avoid the default inference of `Account Id`.

**Example** of `field_map` for `MyAccountClass` (from above):

    def output_fields
      [:account_id, :first_name, :last_name, :email1, :email2, :email3]
    end

Each provided `Neon::` class has a default set of `output_fields` already defined and described below.

Note that these symbols must either be explicitly specified in the `field_map` or they will be inferred from the symbol itself.

### Provided classes

Each of the provided classes offer minimal defaults so they can work immediately for most sites.

#### Neon::Account
This superclass retrieves account information and supports this Neon API request: https://developer.neoncrm.com/api/accounts/searching-for-accounts/list-accounts/

**Defaults**:

    def field_map
      {account_id: 'Account ID'}
    end

    def output_fields
      [:account_id, :first_name, :last_name]
    end

#### Neon::Event
This superclass retrieves event information and supports this Neon API request: https://developer.neoncrm.com/api/events/list-events/

**Defaults**:

    def field_map
      nil    # infer all Neon field names from symbols used
    end

    def output_fields
      [:event_name, :event_start_date, :event_end_date]
    end
