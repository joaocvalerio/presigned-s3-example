class V1::Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    resource = warden.authenticate!(scope: resource_name)

    sign_in(resource_name, resource)

    token = WebToken.encode(resource)

    json_response token: token
  end
end
