class V1::UserPolicy < ApplicationPolicy
  def update?
    user && record && user.id == record.id
  end
end
