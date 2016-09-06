require 'byebug'

module Awesomekit
  class Authenticator
    CONFIG_FILE = '.typekit'

    # PUBLIC: If an API key is not yet saved, prompt the user to
    # enter a new API key and save it to .typekit config file
    def self.get_api_key
      return if api_key

      api_key = prompt_user_for_key

      save_key_to_config(api_key)
    end

    # PUBLIC: Remove the saved API key from config
    def self.logout
      File.unlink(config) if File.exist?(config)
    end

    private
    # PRIVATE: Return the current saved API key, or nil if no key exists
    def self.api_key
      File.exist?(config) ? File.open(config, 'r').gets : nil
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