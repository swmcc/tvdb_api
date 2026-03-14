# frozen_string_literal: true

module TVDB
  class Error < StandardError; end

  class AuthenticationError < Error; end

  class ConfigurationError < Error; end

  class APIError < Error
    attr_reader :response

    def initialize(message, response = nil)
      @response = response
      super(message)
    end
  end
end
