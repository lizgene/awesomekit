# Awesomekit
Simple Ruby client for the [Typekit API](https://typekit.com).

## Installation

`$ gem install awesomekit`

## Setup

Create an account at [typekit.com](https://typekit.com) and generate an API token [here](https://typekit.com/account/tokens).

Save your API token in the default config destination `.typekit`
Or, via the CLI, you will be prompted to enter your API token upon your first request to the Typekit servers.

## Examples

You can access the API directly within Ruby or from your terminal.

### Ruby

To get a list of all available kits:

```ruby
>> require 'awesomekit'
=> true
>> client = Awesomekit::Client.new("your_api_token")
=> #<Awesomekit::Client:0x007f8639345640>
>> client.get_kits
```

To get detailed information on a single kit:

_By default, this will return the current draft version of your kit. You can also
pass a second boolean argument `published` to see the current published version._

```ruby
>> require 'awesomekit'
=> true
>> client = Awesomekit::Client.new("your_api_token")
=> #<Awesomekit::Client:0x007f8639345640>
>> client.get_kit("your_kit_id") # current draft version
>> client.get_kit("your_kit_id", true) # published version
```

### CLI

Option                        | Description
------------------------------|--------------------------------------------------
`awesomekit logout` | Remove your Adobe Typekit API token
`awesomekit list` | List available kits associated with the logged in user
`awesomekit list --verbose` | Display all available kits with kit detail information
`typekit show --id=ID` | Display detail information about the kit specified by the required id option

## Testing

Tests are written with [rspec](http://rspec.info/) with HTTP requests mocked with [vcr](https://github.com/vcr/vcr) and can be run with `bundle exec rspec`

## TODO

- There are plenty of endpoints not yet implemented here - let's get cracking!
- Move api_token to ENV so this can be used nicely in a Rails app
- Structure and return kits more like "kit objects," vs. json hashes full of data
- Improve the authentication flow with a `login`
 method and better separation of duties in the `Authenticator` class.
- Improve specs
- Make printing prettier - currently is a mix of puts and `awesome_print` for more complicated data structures.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

MIT
