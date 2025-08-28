# frozen_string_literal: true

module Internal
  # Internal::BaseController
  class BaseController < ApplicationController
    include ApiPagination

    before_action :authorize_request

    def authorize_request
      header = request.headers['Authorization']
      token = header.split.last if header.present?
      decoded = Auth::JwtService.decode(token:, secret_key:)

      return if decoded == ENV['INTERNAL_SECRET']

      raise UnauthorizedRequest
    end

    private

    def secret_key
      ENV['INTERNAL_TOKEN']
    end
  end
end
