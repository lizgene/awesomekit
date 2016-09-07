require 'awesomekit'
require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_casettes"
  config.hook_into :webmock
  config.filter_sensitive_data("<API_KEY>") do |interaction|
    interaction.request.headers['X-Typekit-Token'].first
  end
end

RSpec.configure do |config|
  config.order = :random

  # Silence input and output for specs
  # Comment out this line if you want to use a debugger while testing
  config.before do
    allow($stdout).to receive(:puts)
    allow($stdin).to receive(:gets) { 'foobar' } # stub user input
  end

  # Capture and return stdout output for inspection
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end
end
