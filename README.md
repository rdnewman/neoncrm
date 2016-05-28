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

To use the gem, two environment variables must be set:
* `NEON_API_KEY`:  get this from your Neon account.
* `NEON_ORG_ID`: this is your organization short name provided from Neon and used for all your Neon page access
