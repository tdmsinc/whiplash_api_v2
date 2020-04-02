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

      private

      def with_error_handling(method, endpoint, options = {})
        response = client.public_send(method, endpoint, options)

        raise WhiplashApiV2::UnauthorizedError, response_error(response) if unauthorized?(response)
        raise WhiplashApiV2::RecordNotFound, response_error(response) if not_found?(response)
        raise WhiplashApiV2::UnknownError, response_error(response) if unknown_error?(response)

        yield response
      end

      def response_error(response)
        response.parsed_response['error'] || response.message
      rescue StandardError => e
        [response.message, e.message].join(' | ')
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
    end
  end
end
