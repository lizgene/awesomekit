require 'thor'
require 'byebug'

module Awesomekit
  class CLI < Thor
    include Thor::Actions

    desc 'logout', 'Remove your Adobe Typekit API key'
    def logout
      Awesomekit::Authenticator.logout
      Formatador.display_line('[yellow]Successfully logged out[/]')
    end

    desc 'list', 'List available kits'
    method_option :verbose, type: :boolean
    method_option :published, default: false, type: :boolean, :aliases => "-p",
      description: 'Flag to return information on the current
      published version of the kit. Defaults to false, or draft kit version.'
    def list
      kits = typekit_client.get_kits
      return not_found if kits.empty?

      display_kits(kits)

      if options[:verbose]
        kits.each do |kit|
          kit = typekit_client.get_kit(kit['id'], options[:published])
          display_kit_detail(kit)
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

      display_kit_detail(kit)
    end

    private

    def display_kits(kits)
      Formatador.display_line("[bold]Your Kits:[/]")
      Formatador.display_table(kits)
    end

    def display_kit_detail(kit)
      Formatador.display_line("[blue]Kit: #{kit['name']}[/]")
      kit_data = [{
        id: kit['id'],
        domains: kit['domains'].join(','),
        analytics: kit['analytics'].to_s
      }]
      Formatador.display_table(kit_data, [:id, :domains, :analytics])

      Formatador.display_line("[bold]#{kit['name']} Families:[/]")
      kit['families'].each do |family|
        display_family_detail(family)
      end
    end

    def display_family_detail(family)
      family_data = [{
        name: family['name'],
        id: family['id'],
        slug: family['slug'],
        css_names: family['css_names'].join(',')
      }]
      Formatador.display_table(family_data, [:name, :id, :slug, :css_names])
    end

    def not_found
      Formatador.display_line('[red]No kits found[/]')
    end

    def typekit_client
      @client ||= Awesomekit::Client.new(Awesomekit::Authenticator.api_key)
    end
  end
end
