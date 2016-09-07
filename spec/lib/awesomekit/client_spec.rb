module Awesomekit
  describe Client do
    # At the moment, to regenerate casettes, you should reassign your
    # API_TOKEN and KIT_ID accordingly.
    let(:api_token) { 'foobar' }
    let(:kit_id) { 'zxg2svq' }
    let(:client) { described_class.new(api_token) }
    let(:output) { capture(:stdout) { subject } }

    before do
      allow(Awesomekit::Authenticator).to receive(:api_token) { api_token }
    end

    describe '#get_kits' do
      subject { client.get_kits }

      context 'kits returned' do
        around { |spec| VCR.use_cassette('get_kits') { spec.run } }

        it 'returns all kits in the response' do
          kits = subject

          expect(kits.count).to eq(1)
          expect(kits.first['id']).to eq(kit_id)
        end
      end

      context 'no kits returned' do
        around { |spec| VCR.use_cassette('get_kits_not_found') { spec.run } }

        it 'prints an error message' do
          expect(output).to match(/No kits found/)
        end
      end

      context 'error unauthorized request' do
        around { |spec| VCR.use_cassette('get_kits_error') { spec.run } }

        it 'prints an error message and clears the API token' do
          expect(Awesomekit::Authenticator).to receive(:clear_api_token)
          expect(output).to match(/Not authorized/)
        end
      end
    end

    describe '#get_kit' do
      subject { client.get_kit(kit_id, published) }
      let(:published) { false }

      context 'draft kit is requested' do
        around { |spec| VCR.use_cassette('get_kit_draft') { spec.run } }

        it 'returns the draft kit version' do
          kit = subject

          expect(kit['id']).to eq(kit_id)
          expect(kit['families'].count).to eq(2)
        end
      end

      context 'published kit is requested' do
        let(:published) { true }

        around { |spec| VCR.use_cassette('get_kit_published') { spec.run } }

        it 'returns the published kit version' do
          kit = subject

          expect(kit['id']).to eq(kit_id)
          expect(kit['families'].count).to eq(1)
        end
      end

      context 'no kit is found' do
        let(:kit_id) { 'bananas' }

        around { |spec| VCR.use_cassette('get_kit_error') { spec.run } }

        it 'prints an error message but does not clear the API token' do
          expect(Awesomekit::Authenticator).not_to receive(:clear_api_token)
          expect(output).to match(/Not Found/)
        end
      end
    end
  end
end
