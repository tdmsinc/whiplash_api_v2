module WhiplashApiV2
  module Resources
    class OrderItem < Base
      endpoint '/order_items'

      def all(order_id)
        end_point = "/orders/#{order_id}#{endpoint}"
        with_error_handling(:get, end_point, &:parsed_response)
      end
    end
  end
end
