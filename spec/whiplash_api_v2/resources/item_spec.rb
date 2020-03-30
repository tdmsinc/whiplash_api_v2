RSpec.describe WhiplashApiV2::Resources::Item do
  let(:access_token) { 'access token' }
  let(:client) { WhiplashApiV2::Client.new(access_token, test: true) }
  let(:base_uri) { client.class.default_options[:base_uri] }
  let(:resource) { described_class.new(client) }
  let(:status) { 200 }

  before do
    stub_request(:get, "#{base_uri}/items/count")
      .to_return(status: status, body: fixture(:records_count))
    stub_request(:get, "#{base_uri}/items")
      .to_return(status: status, body: fixture(:records))
    stub_request(:get, "#{base_uri}/items/1")
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
end