require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build :random_user }

  it 'is valid with valid attributes' do
    expect(build(:user)).to be_valid
  end

  it 'is not valid without a name' do
    user.name = nil
    expect(user).to_not be_valid
  end
end
