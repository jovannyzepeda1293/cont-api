# frozen_string_literal: true

module Auth
  # Auth::JwtService
  class JwtService
    ALGORITHM = 'HS256'

    def self.encode(payload:, secret_key:)
      JWT.encode(payload, secret_key, ALGORITHM)
    end

    def self.decode(token:, secret_key:)
      decoded_token = JWT.decode(token, secret_key, true, { algorithm: ALGORITHM })
      decoded_token[0]
    rescue JWT::DecodeError
      nil
    end
  end
end
