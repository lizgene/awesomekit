module Awesomekit
  describe CLI do
    subject { described_class.new }

    before do
      allow_any_instance_of(Awesomekit::Client).to receive(:get_kits) { kits }
      allow_any_instance_of(Awesomekit::Client).to receive(:get_kit) { kit_detail }
    end

    let(:kit_detail) do
      {
        'id' => 'foo',
        'name' => 'Foo Kit',
        'analytics' => 'true',
        'domains' => ['foobar.com'],
        'families' => []
      }
    end
    let(:kits) do
      [
        { 'id' => 'foo', 'link' => '/api/v1/json/kits/foo' },
        { 'id' => 'bar', 'link' => '/api/v1/json/kits/bar' },
      ]
    end

    describe '#list' do
      let(:output) { capture(:stdout) { subject.list } }

      context 'kits found' do
        it 'displays results for all returned kits' do
          expect(output).to include('foo', '/api/v1/json/kits/foo')
          expect(output).to include('bar', '/api/v1/json/kits/bar')
          expect(output).not_to include('foobar.com')
        end
      end

      context 'no kits found' do
        let(:kits) { [] }

        it 'displays an error message' do
          expect(output).to include('No kits found')
        end
      end

      context 'verbose' do
        let(:output) do
          capture(:stdout) do
            subject.options = { verbose: true }
            subject.list
          end
        end

        it 'displays kit details in the results' do
          expect(output).to include('foo', '/api/v1/json/kits/foo')
          expect(output).to include('bar', '/api/v1/json/kits/bar')
          expect(output).to include('foobar.com')
        end
      end
    end

    describe '#show' do
      let(:output) do
        capture(:stdout) { subject.show }
      end

      it 'displays kit detail results' do
        expect(output).to include('foo', 'Foo Kit', 'true', 'foobar.com')
      end
    end

    describe '#logout' do
      # Silence Formatador output
      before { allow(Formatador).to receive(:display_line) }

      it 'clears the existing API key' do
        expect(Awesomekit::Authenticator).to receive(:clear_api_key)

        subject.logout
      end
    end
  end
end
