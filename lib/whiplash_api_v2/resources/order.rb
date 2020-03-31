module WhiplashApiV2
  module Resources
    class Order < Base
      endpoint '/orders'

      def call_action(order_id, action)
        end_point = "#{endpoint}/#{order_id}/call/#{action}"
        with_error_handling(:put, end_point, &:parsed_response)
      end
    end
  end
end
