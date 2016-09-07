require 'byebug'
module Awesomekit
  class Authenticator
    CONFIG_FILE = '.typekit'

    # PUBLIC: Return the current saved api_token
    # If no token exists, prompt user for token
    def self.api_token
      if File.exist?(config)
        File.open(config, 'r').gets
      end
    end

    # PUBLIC: Delete any existing api_token config file
    def self.clear_api_token
      File.unlink(config) if api_token
    end

    def self.get_or_set_api_token
      return api_token if api_token

      prompt_user_for_token
    end

    private

    def self.prompt_user_for_token
      print("Enter your Adobe Typekit API token: \n")
      api_token = STDIN.gets.chomp
      save_token_to_config(api_token)
      api_token
    end

    def self.save_token_to_config(api_token)
      File.open(config, 'w') do |file|
        file.write(api_token)
      end
    end

    def self.config
      File.join(Dir.home, CONFIG_FILE)
    end
  end
end
