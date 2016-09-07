require 'thor'
require 'awesome_print'

module Awesomekit
  class CLI < Thor
    include Thor::Actions

    desc 'logout', 'Remove your Adobe Typekit API token'
    def logout
      Awesomekit::Authenticator.clear_api_token
      ap('Successfully logged out', color: { string: :yellow })
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
      @client ||= Awesomekit::Client.new
    end
  end
end
