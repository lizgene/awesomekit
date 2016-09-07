require 'spec_helper'

module Awesomekit
  describe Authenticator do
    let(:api_key) { 'foobar' }
    let(:config_file) { double(:file) }
    let(:config_path) { described_class::CONFIG_FILE }

    before do
      allow(described_class).to receive(:config) { config_path }
    end

    describe '.api_key' do
      subject { described_class.api_key }

      context 'API key exists' do
        before do
          allow(config_file).to receive(:gets) { api_key }
          allow(File).to receive(:exist?) { true }
          allow(File).to receive(:open).with(config_path, 'r') { config_file }
        end

        it 'does not save to the config file and returns the API key' do
          expect(config_file).not_to receive(:write).with(api_key)
          expect(subject).to eq(api_key)
        end
      end

      context 'API key does not exist' do
        before do
          allow(Formatador).to receive(:display)
          allow(File).to receive(:exist?) { false }
          allow(STDIN).to receive_message_chain(:gets, :chomp) { api_key }
          allow(File).to receive(:open).with(config_path, 'w').and_yield(config_file)
        end

        it 'saves user API key to the config file' do
          expect(config_file).to receive(:write).with(api_key)
          expect(subject).to eq(api_key)
        end
      end
    end

    describe '.clear_api_key' do
      before { allow(File).to receive(:exist?) { true } }

      it 'removes the file' do
        expect(File).to receive(:unlink).with(config_path)

        described_class.clear_api_key
      end
    end
  end
end
