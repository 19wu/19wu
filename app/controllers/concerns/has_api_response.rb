# TODO: handle authentication error
module HasApiResponse
  extend ActiveSupport::Concern

  # rails http response status code to symbol mapping
  # http://guides.rubyonrails.org/layouts_and_rendering.html#the-status-option

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
