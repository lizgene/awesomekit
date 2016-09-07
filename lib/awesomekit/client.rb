require 'httparty'

module Awesomekit
  class Client
    include HTTParty

    base_uri 'https://typekit.com/api/v1/json'

    def initialize(api_token)
      self.class.headers('X-Typekit-Token' => api_token)
    end
    # PUBLIC: Returns a list of kits owned by the authenticating user
    # Endpoint reference: https://typekit.com/docs/api/v1/:format/kits
    def get_kits
      response = self.class.get("/kits")

      return if process_errors(response)

      # If no kits are found, an empty array is returned (not a Not Found error)
      kits = response['kits']
      return not_found if kits.nil? || kits.empty?

      kits
    end

    # PUBLIC: Returns information about a kit found by kit_id
    # Endpoint reference: https://typekit.com/docs/api/v1/:format/kits/:kit
    #
    # published=false returns the default, current draft version of the kit
    # published=true returns the current published version of a kit
    def get_kit(kit_id, published=false)
      if published
        response = self.class.get("/kits/#{kit_id}/published")
      else
        response = self.class.get("/kits/#{kit_id}")
      end

      return if process_errors(response)

      response['kit']
    end

    private

    # PRIVATE: Display any error messages returned by Typekit.
    #
    # Automatically removes an invalid api_token if error is a 401 not authorized,
    # so the user will be prompted to enter a new token on their next request.
    def process_errors(response)
      if response['errors']
        errors = 'The server responded with the following error(s): '
        errors << response['errors'].join(',')

        if errors.include?('Not authorized')
          Awesomekit::Authenticator.clear_api_token
        end

        print("\e[31m#{errors}\e[0m\n")

        return true
      end
    end

    def not_found
      print("\e[31mNo kits found\e[0m\n")
    end
  end
end
