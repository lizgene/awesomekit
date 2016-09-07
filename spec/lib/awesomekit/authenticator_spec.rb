require 'spec_helper'

module Awesomekit
  describe Authenticator do
    # let(:api_token) { 'foobar' }
    # let(:config_file) { double(:file) }
    # let(:config_path) { described_class::CONFIG_FILE }
    #
    # before do
    #   allow(described_class).to receive(:config) { config_path }
    # end
    #
    # describe '.api_token' do
    #   subject { described_class.api_token }
    #
    #   context 'API token exists' do
    #     before do
    #       allow(config_file).to receive(:gets) { api_token }
    #       allow(File).to receive(:exist?) { true }
    #       allow(File).to receive(:open).with(config_path, 'r') { config_file }
    #     end
    #
    #     it 'does not save to the config file and returns the API token' do
    #       expect(config_file).not_to receive(:write).with(api_token)
    #       expect(subject).to eq(api_token)
    #     end
    #   end
    #
    #   context 'API token does not exist' do
    #     before do
    #       allow(File).to receive(:exist?) { false }
    #     end
    #
    #     it 'returns nil' do
    #       expect(subject).to be_nil
    #     end
    #   end
    # end
    #
    # describe '.get_or_set_api_token' do
    #   subject { described_class.get_or_set_api_token }
    #
    #   context 'API token exists' do
    #     before do
    #       allow(config_file).to receive(:gets) { api_token }
    #       allow(File).to receive(:exist?) { true }
    #       allow(File).to receive(:open).with(config_path, 'r') { config_file }
    #     end
    #
    #     it 'returns the API token' do
    #       expect(subject).to eq(api_token)
    #     end
    #   end
    #
    #   context 'API token does not exist' do
    #     before do
    #       allow(File).to receive(:exist?) { false }
    #     end
    #
    #     it 'returns the API token' do
    #       expect(described_class).to receive(:prompt_user_for_token)
    #
    #       subject
    #     end
    #   end
    # end
    #
    # describe '.clear_api_token' do
    #   before do
    #     allow(config_file).to receive(:gets) { api_token }
    #     allow(File).to receive(:exist?) { true }
    #     allow(File).to receive(:open).with(config_path, 'r') { config_file }
    #   end
    #
    #   it 'removes the file' do
    #     expect(File).to receive(:unlink).with(config_path)
    #
    #     described_class.clear_api_token
    #   end
    # end
  end
end
