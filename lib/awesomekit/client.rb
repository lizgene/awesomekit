require 'httparty'
require 'byebug'

module Awesomekit
  class Client
    include HTTParty

    attr_reader :auth_token

    base_uri 'https://typekit.com/api/v1/json'

    def initialize(api_key)
      self.class.headers('X-Typekit-Token' => api_key)
    end

    # PUBLIC: Returns a list of kits owned by the authenticating user
    # Endpoint reference: https://typekit.com/docs/api/v1/:format/kits
    def get_kits
      response = self.class.get("/kits")

      process_errors(response)

      response['kits']
    end

    # PUBLIC: Returns information about a kit found by kit_id
    # Endpoint reference: https://typekit.com/docs/api/v1/:format/kits/:kit
    #
    # published=false returns the default, draft version of the kit
    # published=true returns information about the published version of a kit
    def get_kit(kit_id, published)
      if published
        response = self.class.get("/kits/#{kit_id}/published")
      else
        response = self.class.get("/kits/#{kit_id}")
      end

      process_errors(response)

      response['kit']
    end

    private

    # PRIVATE: Display any error messages returned by Typekit.
    #
    # Automatically removes an invalid api_key if error is a 401 not authorized,
    # so the user will be prompted to enter a new key on their next request.
    def process_errors(response)
      if response['errors']
        errors = '[red]The server responded with the following error(s):[/] '
        errors << response['errors'].join(',')

        Awesomekit::Authenticator.logout if errors.include?('Not authorized')

        Formatador.display_line(errors)

        exit
      end
    end
  end
end
