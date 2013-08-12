# TODO: handle authentication error
module HasApiResponse
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid_error
  end

  protected
  def render_record_invalid_error(exception)
    payload = {
      result: 'error',
      type: 'record_invalid',
      errors: exception.record.errors.full_messages
    }

    render json: payload, status: :not_acceptable
  end
end
