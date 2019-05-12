class Jwt
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :token
end
