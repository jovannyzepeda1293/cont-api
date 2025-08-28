# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::API
  rescue_from UnauthorizedRequest, with: :unauthorized_resquest
  rescue_from ArgumentError, with: :argument_error

  private

  def unauthorized_resquest
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def argument_error(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end
