module WhiplashApiV2
  module Resources
    class Base
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def self.endpoint(end_point = nil)
        @endpoint ||= end_point
      end

      def endpoint
        @endpoint = self.class.endpoint
        raise WhiplashApiV2::EndpointNotDefined unless @endpoint

        @endpoint
      end

      def all(options = {})
        with_error_handling(:get, endpoint, query: options, &:parsed_response)
      end

      def where(options = {})
        pagination = options.delete(:pagination) || {}
        attrs = options.each_with_object({}) do |(key, value), hash|
          next hash["#{key}_eq"] = value unless value.is_a? Array

          hash["#{key}_in"] = value
        end

        all(pagination.merge(search: attrs.to_json))
      end

      def count(options = {})
        with_error_handling(:get, "#{endpoint}/count", query: options) do |res|
          res.parsed_response['count']
        end
      end

      def find(id)
        with_error_handling(:get, "#{endpoint}/#{id}", &:parsed_response)
      end

      def create(attributes = {})
        with_error_handling(:post, endpoint, body: attributes, &:parsed_response)
      end

      def update(id, attributes = {})
        with_error_handling(:put, "#{endpoint}/#{id}", body: attributes, &:parsed_response)
      end

      private

      def with_error_handling(method, endpoint, options = {})
        response = client.public_send(method, endpoint, options)

        raise WhiplashApiV2::UnauthorizedError, response_error(response) if unauthorized?(response)
        raise WhiplashApiV2::RecordNotFound, response_error(response) if not_found?(response)
        raise WhiplashApiV2::ConflictError, response_error(response) if conflict?(response)
        raise WhiplashApiV2::UnknownError, response_error(response) if unknown_error?(response)

        yield response
      end

      def response_error(response)
        {
          error: [response.parsed_response, response.message].compact.join(' | '),
          requested_url: response.request.last_uri,
          request_options: response.request.options.slice(:headers, :base_uri, :body),
          status: response.code
        }.to_json
      rescue StandardError => e
        [response.body, response.message, e.message].compact.join(' | ')
      end

      def unauthorized?(response)
        response.message.to_s.downcase == 'unauthorized'
      end

      def unknown_error?(response)
        ![200, 201].include? response.code
      end

      def not_found?(response)
        response.code == 404
      end

      def conflict?(response)
        response.code == 409
      end
    end
  end
end
