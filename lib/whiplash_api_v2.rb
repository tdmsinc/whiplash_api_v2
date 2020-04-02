require 'httparty'

require 'whiplash_api_v2/version'
require 'whiplash_api_v2/exceptions'

require 'whiplash_api_v2/resources/base'
require 'whiplash_api_v2/resources/order'
require 'whiplash_api_v2/resources/order_item'
require 'whiplash_api_v2/resources/item'
require 'whiplash_api_v2/resources/customer'

require 'whiplash_api_v2/client'

module WhiplashApiV2
  def self.root
    Pathname.new(File.dirname(__dir__))
  end
end
