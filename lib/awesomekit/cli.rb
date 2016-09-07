require 'thor'
require 'awesome_print'
require 'byebug'

module Awesomekit
  class CLI < Thor
    include Thor::Actions

    desc 'logout', 'Remove your Adobe Typekit API token'
    def logout
      if Awesomekit::Authenticator.api_token
        Awesomekit::Authenticator.clear_api_token
        print("Successfully logged out\n")
      else
        print("Already logged out. Use command awesomekit login to save a new API key.")
      end
    end

    desc 'login', 'Add or update your Adobe Typekit API token'
    def login
      Awesomekit::Authenticator.clear_api_token
      Awesomekit::Authenticator.get_or_set_api_token

      api_token = Awesomekit::Authenticator.api_token
      print("Your token has been saved as: #{api_token}\n")
    end

    desc 'list', 'List available kits'
    method_option :verbose, type: :boolean
    method_option :published, default: false, type: :boolean, :aliases => "-p",
      description: 'Flag to return information on the current
      published version of the kit. Defaults to false, or draft kit version.'
    def list
      kits = typekit_client.get_kits

      ap(kits) if kits

      if options[:verbose]
        kits.each do |kit|
          kit = typekit_client.get_kit(kit['id'], options[:published])
          ap(kit) if kit
        end
      end
    end

    desc 'show', 'Display a specific kit'
    method_option :id, type: :string, required: true
    method_option :published, default: false, type: :boolean, :aliases => "-p",
      description: 'Flag to return information on the current
      published version of the kit. Defaults to false, or draft kit version.'
    def show
      kit = typekit_client.get_kit(options[:id], options[:published])

      ap(kit) if kit
    end

    private

    def typekit_client
      @client ||=
        Awesomekit::Client.new(Awesomekit::Authenticator.get_or_set_api_token)
    end
  end
end
