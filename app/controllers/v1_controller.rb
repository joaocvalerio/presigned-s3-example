class V1Controller < ApplicationController
  def pundit_user(context = {})
    { user: current_user }.merge(context)
  end
end
