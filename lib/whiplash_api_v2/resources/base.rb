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

      private

      def with_error_handling(method, endpoint, options = {})
        response = client.public_send(method, endpoint, options)

        raise WhiplashApiV2::UnauthorizedError if unauthorized?(response)
        raise WhiplashApiV2::UnknownError if unknown_error?(response)

        yield response
      end

      def unauthorized?(response)
        response.message.to_s.downcase == 'unauthorized'
      end

      def unknown_error?(response)
        response.code != 200
      end
    end
  end
end
