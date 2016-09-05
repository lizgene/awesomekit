require 'thor'

module Awesomekit
  class CLI < Thor
    include Thor::Actions

    desc 'logout', 'Remove your Adobe Typekit API key'
    def logout
      Awesomekit::Authenticator.logout
      Formatador.display_line('[yellow]Successfully logged out[/]')
    end

    desc 'list', 'List available kits'
    def list
      kits = @client.get_kits

      kits.each { |kit| display_kit(kit) }
    end

    desc 'show', 'Display a specific kit'
    method_option :id, type: :string, required: true
    method_option :published, default: false, type: :boolean, :aliases => "-p",
      description: 'Flag to return information on the current
      published version of the kit. Defaults to false, or draft kit version.'
    def show
      kit = @client.get_kit(options[:id])

      display_kit(kit)
    end

    private

    # TODO: Error handling. Possibly for the client?
    # return not_found if kits.empty?
    # return display_errors(kits) if kits.key?('errors')
    def display_errors(response)
      errors = '[red]The server responded with the following error(s):[/] '
      errors << response['errors'].join(',')

      Formatador.display_line(errors)
    end

    def not_found
      Formatador.display_line('[red]No kits found[/]')
    end

    # TODO: Move this to a formatting class
    def display_kit(kit)
      Formatador.display_line("[bold]Name:[/] #{kit['name']}")
      Formatador.display_line("[bold]ID:[/] #{kit['id']}")
      Formatador.display_line("[bold]Analytics:[/] #{kit['analytics']}")
      Formatador.display_line("[bold]Domains:[/] #{kit['domains'].join(',')}")

      Formatador.display_line('[bold]Families:[/]')

      Formatador.indent do
        kit['families'].each do |family|
          Formatador.display_line("[bold]Name:[/] #{family['name']}")
          Formatador.display_line("[bold]ID:[/] #{family['id']}")
          Formatador.display_line("[bold]Slug:[/] #{family['slug']}")
          Formatador.display_line("[bold]CSS Names:[/] #{family['css_names'].join(',')}\n")
        end
      end
    end

    def typekit_client
      @client ||= Awesomekit::Client.new(Awesomekit::Authenticator.api_key)
    end
  end
end
