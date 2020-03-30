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

  context 'when endpoint not defined' do
    before { allow(described_class).to receive(:endpoint) }

    it 'raises exception' do
      expect { resource.all }.to raise_error WhiplashApiV2::EndpointNotDefined
    end
  end
end
