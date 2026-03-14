# frozen_string_literal: true

require_relative 'tvdb_api/version'
require_relative 'tvdb_api/errors'
require_relative 'tvdb_api/middleware/authentication'
require_relative 'tvdb_api/client'

# Backwards compatibility alias
TVDBApi = TVDB::Client

# Legacy middleware alias
TVDBAPIMiddleware = TVDB::Middleware::Authentication
