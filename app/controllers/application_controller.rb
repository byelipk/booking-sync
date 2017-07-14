class ApplicationController < ActionController::API
  # Tell our controllers that we accept and generate JSONAPI data
  include ActionController::MimeResponds

  rescue_from ActiveRecord::RecordNotFound, with: :resource_not_found

  def ensure_authenticated_request
    auth_token = request.headers.fetch("X-HAPPY-DAYS") { false }

    if auth_token && auth_token == "make-me-feel-fine"
      true
    else
      response.headers["WWW-Authenticate"] = "Token realm='Access to site'"

      head :unauthorized
    end
  end

  def resource_not_found(exception)
    render jsonapi: {
      errors: {
        id: exception.id,
        status: 404,
        code: "not-found",
        title: "Resource Not Found",
        detail: exception.message
      }
    }, status: 404
  end
end
