class ApplicationController < ActionController::API
  include Pundit

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

  AuthorizationException = Class.new(StandardError)

  rescue_from StandardError do |exception|
    render_server_error!
  end

  rescue_from ApplicationController::AuthorizationException do |exception|
    render_unauthorized!
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    current_user
  end

  def user_not_authorized(exception)
    json_response(Empty.new, status: :unauthorized,
      meta: { status: 'KO', message: "Unauthorized #{exception.policy.class.to_s.underscore.camelize}.#{exception.query}" })
  end

  def render_server_error!
    json_response(
      Empty.new,
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

  def render_not_found!
    json_response(
      Empty.new,
      status: :not_found,
      meta: { status: 'KO', message: 'The resource you are looking for does not exist' }
    )
  end

  def render_unauthorized!
    json_response(
      Empty.new,
      status: :unauthorized,
      meta: { status: 'KO', message: 'Authorization failed' }
    )
  end

  def serialize_errors(errors)
    errors.messages
  end
end
