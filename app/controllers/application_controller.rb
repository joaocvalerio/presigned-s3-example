class ApplicationController < ActionController::API
  def json_response(object, include_data: '', custom_include_data: nil, include_params: nil, meta: {}, status: :ok)
    render_data = {
      json: object,
      include: include_data,
      include_params: custom_include_data || include_params,
      status: status,
      meta: meta,
      adapter: :json
    }

    render(render_data)
  end

  rescue_from StandardError do |exception|
    render_server_error!
  end

  def render_server_error!
    json_response(Empty.new,
      meta: { status: 'KO', message: 'Something went wrong.' },
      status: :internal_server_error
    )
  end

  def render_unprocessable_entity!(errors)
    json_response(
      Empty.new,
      meta: { status: 'KO', message: serialize_errors(errors) },
      status: :unprocessable_entity
    )
  end

  def serialize_errors(errors)
    errors.messages
  end
end
