module Awesomekit
  class Authenticator
    CONFIG_FILE = '.typekit'

    # PUBLIC: Return the current saved api_key
    # If no key exists, prompt user for key
    def self.api_key
      if File.exist?(config)
        File.open(config, 'r').gets
      else
        prompt_user_for_key
      end
    end

    # PUBLIC: Delete any existing api_key config file
    def self.clear_api_key
      File.unlink(config) if File.exist?(config)
    end

    private

    def self.prompt_user_for_key
      Formatador.display('[yellow]Please enter your Adobe Typekit API key: [/]')
      api_key = STDIN.gets.chomp
      save_key_to_config(api_key)
      api_key
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
