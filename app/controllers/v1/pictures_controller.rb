class V1::PicturesController < V1Controller
  before_action :authenticate_user!, only: [:create]

  def create
    service_params = permitted_attributes.merge(user: current_user)
    service = V1::Pictures::CreateService.new(service_params)

    if service.call
      json_response Empty.new,
      meta: {
        presign_object: service.presigned_object
      }
    else
      render_unprocessable_entity!(service.errors)
    end
  end

  private

  def permitted_attributes
    params.require(:picture).permit(
      :picture_file_name
    )
  end
end
