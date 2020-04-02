RSpec.describe WhiplashApiV2::Resources::OrderItem do
  let(:access_token) { 'access token' }
  let(:client) { WhiplashApiV2::Client.new(access_token, test: true) }
  let(:base_uri) { client.class.default_options[:base_uri] }
  let(:resource) { described_class.new(client) }
  let(:status) { 200 }

  before do
    stub_request(:get, "#{base_uri}/orders/1/order_items")
      .to_return(status: status, body: fixture(:records))
    stub_request(:get, "#{base_uri}/order_items/1")
      .to_return(status: status, body: fixture(:record))
    stub_request(:put, "#{base_uri}/order_items/1")
      .to_return(status: status, body: fixture(:record))
  end

  it 'returns order items' do
    expect(resource.all(1)).to be_any

    resource.all(1).each do |record|
      expect(record).to be_a Hash
    end
  end

  it 'finds the order item' do
    expect(resource.find(1)).to be_a Hash
  end

  it 'updates the record' do
    expect(resource.update(1, {})).to be_a Hash
  end
end
