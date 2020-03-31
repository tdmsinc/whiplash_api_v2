module WhiplashApiV2
  class Client
    include HTTParty

    format :json

    attr_reader :options

    def initialize(access_token, options = {})
      @access_token = access_token
      @options = options

      self.class.default_options.merge!(
        base_uri: api_url,
        headers: { 'Authorization' => "Bearer #{access_token}" }
      )
    end

    %i[get post put].each do |method|
      define_method method do |endpoint, options = {}|
        self.class.public_send(method, endpoint, options)
      end
    end

    private

    def method_missing(method, *args, &block)
      return super unless resource_name?(method)

      get_resource(method).new(self)
    end

    def respond_to_missing?(method, *args)
      resource_name?(method) || super
    end

    def get_resource(name)
      klass = "WhiplashApiV2::Resources::#{name.capitalize}"
      Object.const_defined?(klass) ? Object.const_get(klass) : OpenStruct
    end

    def resource_name?(name)
      resources_path = WhiplashApiV2.root.join('lib/whiplash_api_v2/resources')
      resources_path.glob('*.rb').any? { |p| p.to_s["#{name}.rb"] }
    end

    def api_url
      prod_url = 'https://www.getwhiplash.com/api/v2'
      sandbox_url = 'https://sandbox.getwhiplash.com/api/v2'
      options[:test] ? sandbox_url : prod_url
    end
  end
end
