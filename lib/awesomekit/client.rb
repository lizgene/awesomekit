require 'httparty'

module Awesomekit
  class Client
    include HTTParty

    attr_reader :auth_token

    base_uri 'https://typekit.com/api/v1/json'

    def initialize(api_key)
      self.class.headers('X-Typekit-Token' => api_key)
    end

    # PUBLIC: Returns a list of kits owned by the authenticating user
    def get_kits
      self.class.get("/kits")
    end

    # PUBLIC: Returns information about a kit found by kit_id
    #
    # published=false returns the default, draft version of the kit
    # published=true returns information about the published version of a kit
    def get_kit(kit_id, published)
      return self.class.get("/kit/#{kit_id}/published") if published_version

      self.class.get("/kit/#{kit_id}")
    end
  end
end
