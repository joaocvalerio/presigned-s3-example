class UserSerializer < ActiveModel::Serializer
  attributes :id,
    :name,
    :email,
    :profile_picture_url

  has_many :pictures
end
