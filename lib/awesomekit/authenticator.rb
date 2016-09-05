module Awesomekit
  class Authenticator

    # PUBLIC: If an API key is not yet saved, or is invalid, prompt the user to
    # enter a new API key and save it to .typekit config file
    def self.authorize!
      return if valid_api_key?

      api_key = prompt_for_user_key

      save_or_update_key(api_key)
    end

    # PUBLIC: Return the current saved API key, or nil if no key is saved.
    def self.api_key
      File.exist?(config) ? File.open(config, 'r').gets : nil
    end

    # PUBLIC: Remove the saved API key from .typekit config
    def self.logout
      File.unlink(config) if File.exist?(config)
    end

    private

    # TODO: Verify with the TypeKit server if this token is valid
    def valid_api_key?
      true
    end

    def prompt_for_user_key
      Formatador.display('[yellow]Please enter your Adobe Typekit API key: [/]')
      STDIN.gets.chomp
    end

    def save_or_update_key(api_key)
      File.open(config, 'w') do |file|
        file.write(api_key)
      end
    end

    def config
      File.join(Dir.home, '.typekit')
    end
  end
end
