module Awesomekit
  class Authenticator
    CONFIG_FILE = '.typekit'

    # PUBLIC: Get the existing api_key or prompt user for an api_key
    # if the requested action requires Typekit authentication.
    def authenticate(cli_args)
      non_auth_actions = ['logout', 'help']
      requires_authentication = (cli_args - non_auth_actions).any?

      get_or_set_api_key if requires_authentication
    end

    # PUBLIC: Delete any existing api_key config file
    def self.clear_api_key
      File.unlink(config) if File.exist?(config)
    end

    # PUBLIC: Return the current saved api_key, nil if no key exists
    def self.api_key
      File.exist?(config) ? File.open(config, 'r').gets : nil
    end

    private

    def self.get_or_set_api_key
      return if api_key

      api_key = prompt_user_for_key

      save_key_to_config(api_key)
    end

    def self.prompt_user_for_key
      Formatador.display('[yellow]Please enter your Adobe Typekit API key: [/]')
      STDIN.gets.chomp
    end

    def self.save_key_to_config(api_key)
      File.open(config, 'w') do |file|
        file.write(api_key)
      end
    end

    def self.config
      File.join(Dir.home, CONFIG_FILE)
    end
  end
end
