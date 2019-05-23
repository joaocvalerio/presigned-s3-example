class V1::UsersController < V1Controller
  before_action :authenticate_user!, only: [:show, :update]
  before_action :set_user, only: [:show, :update]

  def show
    return render_not_found! unless @user

    if current_user.id == @user.id
      json_response(@user, include_data: :pictures)
    else
      render_unauthorized!
    end
  end

  def update
    return render_not_found! unless @user

    authorize([:v1, @user])

    service_params = permitted_attributes_for_update
    service_params = service_params.merge(user: @user)

    service = V1::Users::UpdateService.new(service_params)

    if service.call
      json_response(
        @user,
        meta: {
          jwt: Jwt.new(token: WebToken.encode(@user)),
          presign_object: service.presigned_object
        }
      )
    else
      render_unprocessable_entity!(service.errors)
    end
  end

  private

  def permitted_attributes_for_update
    params.require(:user).permit(
      :name,
      :email,
      :profile_picture_file_name,
      :password
    )
  end

  def set_user
    @user = User.where(id: params[:id]).first
  end

  def show_serializer_includes
    'pictures'
  end
end
