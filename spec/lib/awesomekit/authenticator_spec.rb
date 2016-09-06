require 'spec_helper'

module Awesomekit
  describe Authenticator do
    let(:api_key) { 'foobar' }
    let(:config_file) { double(:file) }
    let(:config_path) { described_class::CONFIG_FILE }

    before do
      allow(described_class).to receive(:config).and_return(config_path)
    end

    describe '.get_api_key' do
      subject { described_class.get_api_key }

      context 'API key exists' do
        before do
          allow(config_file).to receive(:gets).and_return(api_key)
          allow(File).to receive(:exist?).and_return(true)
          allow(File).to receive(:open).with(config_path, 'r').and_return(config_file)
        end

        it 'does not save to the config file' do
          expect(config_file).not_to receive(:write).with(api_key)

          subject
        end
      end

      context 'API key does not exist' do
        before do
          allow(Formatador).to receive(:display)
          allow(File).to receive(:exist?).and_return(false)
          allow(STDIN).to receive_message_chain(:gets, :chomp).and_return(api_key)
          allow(File).to receive(:open).with(config_path, 'w').and_yield(config_file)
        end

        it 'saves user API key to the config file' do
          expect(config_file).to receive(:write).with(api_key)

          subject
        end
      end
    end

    describe '.logout' do
    end
  end
end
