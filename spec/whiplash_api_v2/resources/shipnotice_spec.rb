RSpec.describe WhiplashApiV2::Resources::Shipnotice do
  let(:access_token) { 'access token' }
  let(:client) { WhiplashApiV2::Client.new(access_token, test: true) }
  let(:base_uri) { client.class.default_options[:base_uri] }
  let(:resource) { described_class.new(client) }
  let(:status) { 200 }

  before do
    stub_request(:get, "#{base_uri}/shipnotices/count")
      .to_return(status: status, body: fixture(:records_count))
    stub_request(:get, "#{base_uri}/shipnotices")
      .to_return(status: status, body: fixture(:records))
    stub_request(:get, "#{base_uri}/shipnotices")
      .with(query: { search: { id_eq: 1 }.to_json })
      .to_return(status: status, body: fixture(:records))
    stub_request(:get, "#{base_uri}/shipnotices/1")
      .to_return(status: status, body: fixture(:record))
    stub_request(:post, "#{base_uri}/shipnotices")
      .to_return(status: status, body: fixture(:record))
    stub_request(:put, "#{base_uri}/shipnotices/1")
      .to_return(status: status, body: fixture(:record))
  end

  it { expect(resource.count).to eq 52 }

  it 'returns shipnotices' do
    expect(resource.all).to be_any

    resource.all.each do |record|
      expect(record).to be_a Hash
    end
  end

  it 'returns records' do
    expect(resource.where(id: 1)).to be_any

    resource.where(id: 1).each do |record|
      expect(record).to be_a Hash
    end
  end

  it 'finds the shipnotice' do
    expect(resource.find(1)).to be_a Hash
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
