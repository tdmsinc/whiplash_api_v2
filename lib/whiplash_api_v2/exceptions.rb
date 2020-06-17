module WhiplashApiV2
  class UnauthorizedError < StandardError; end
  class UnknownError < StandardError; end
  class EndpointNotDefined < StandardError; end
  class RecordNotFound < StandardError; end
  class ConflictError < StandardError; end
end
