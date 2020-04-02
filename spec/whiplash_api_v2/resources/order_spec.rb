RSpec.describe WhiplashApiV2::Resources::Order do
  let(:access_token) { 'access token' }
  let(:client) { WhiplashApiV2::Client.new(access_token, test: true) }
  let(:base_uri) { client.class.default_options[:base_uri] }
  let(:resource) { described_class.new(client) }
  let(:status) { 200 }

  before do
    stub_request(:get, "#{base_uri}/orders/count")
      .to_return(status: status, body: fixture(:records_count))
    stub_request(:get, "#{base_uri}/orders")
      .to_return(status: status, body: fixture(:records))
    stub_request(:get, "#{base_uri}/orders/1")
      .to_return(status: status, body: fixture(:record))
    stub_request(:put, "#{base_uri}/orders/1/call/pause")
      .to_return(status: status, body: fixture(:record))
    stub_request(:post, "#{base_uri}/orders")
      .to_return(status: status, body: fixture(:record))
    stub_request(:put, "#{base_uri}/orders/1")
      .to_return(status: status, body: fixture(:record))
  end

  it { expect(resource.count).to eq 52 }

  it 'returns orders' do
    expect(resource.all).to be_any

    resource.all.each do |record|
      expect(record).to be_a Hash
    end
  end

  it 'finds the order' do
    expect(resource.find(1)).to be_a Hash
  end

  context 'when access token is not authorized' do
    before do
      allow_any_instance_of(HTTParty::Response).to receive(:message)
        .and_return('Unauthorized')
    end

    it 'raises exception' do
      expect { resource.all }.to raise_error WhiplashApiV2::UnauthorizedError
    end
  end

  context 'when response code is not equal to 200' do
    let(:status) { 403 }

    it 'raises exception' do
      expect { resource.count }.to raise_error WhiplashApiV2::UnknownError
    end
  end

  context 'when record not found' do
    let(:status) { 404 }

    it 'raises exception' do
      expect { resource.count }.to raise_error WhiplashApiV2::RecordNotFound
    end
  end

  context 'when endpoint not defined' do
    before { allow(described_class).to receive(:endpoint) }

    it 'raises exception' do
      expect { resource.all }.to raise_error WhiplashApiV2::EndpointNotDefined
    end
  end

  describe '#call_action' do
    let(:call_action) { resource.call_action(1, :pause) }

    it 'calls cancel action on order' do
      expect(call_action).to be_a Hash
      expect(call_action).to have_key('id')
    end
  end

  it 'updates the record' do
    expect(resource.update(1, {})).to be_a Hash
  end

  describe '#create' do
    it { expect(resource.create({})).to be_a Hash }

    context 'when status code is not equal to 201' do
      let(:status) { 422 }

      it 'raises exception' do
        expect { resource.create({}) }
          .to raise_error WhiplashApiV2::UnknownError
      end
    end
  end
end
