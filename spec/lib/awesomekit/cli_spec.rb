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
        it 'prints results for all returned kits' do
          expect(output).to include('foo', '/api/v1/json/kits/foo')
          expect(output).to include('bar', '/api/v1/json/kits/bar')
          expect(output).not_to include('foobar.com')
        end
      end

      context 'kits not found' do
        let(:kits) { [] }

        it 'does not print results' do
          expect(output).not_to include('foo', '/api/v1/json/kits/foo')
        end
      end

      context 'verbose' do
        let(:output) do
          capture(:stdout) do
            subject.options = { verbose: true }
            subject.list
          end
        end

        it 'prints kit details' do
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

      it 'prints kit details' do
        expect(output).to include('foo', 'Foo Kit', 'true', 'foobar.com')
      end
    end

    describe '#logout' do
      let(:output) do
        capture(:stdout) { subject.logout }
      end

      context 'API token exists' do
        it 'clears the existing API token' do
          expect(Awesomekit::Authenticator).to receive(:clear_api_token)

          expect(output).to include('Successfully logged out')
        end
      end

      context 'API token does not exist' do

        before do
          allow_any_instance_of(Awesomekit::Authenticator).to receive(:api_token) { 'abc123' }
        end

        it 'prints the already logged out message' do
          expect(output).to include('Already logged out')
        end
      end
    end
  end
end
