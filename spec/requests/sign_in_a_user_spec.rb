require 'rails_helper'
require 'spec_helper'

describe 'sign in a user', type: :request do
  let(:user) { create :user }
  let(:sign_in_params) { { user: { email: user.email, password: user.password } } }
  let(:headers) { { 'ACCEPT': 'application/json' } }

  before do
    post(
      "/v1/users/sign_in",
      params: sign_in_params,
      headers: headers
    )
  end

  context 'with valid params' do
    it 'responds with a 200 status' do
      expect(response.status).to eq 200
    end

    it 'returns a token' do
      expect(json['jwt']['token']).not_to be_nil
    end
  end

  context 'without email' do
    let(:sign_in_params) { { user: { password: user.password } } }

    it 'responds with a 400 status' do
      expect(response.status).to eq 401
    end
  end

  context 'without password' do
    let(:sign_in_params) { { user: { email: user.email } } }

    it 'responds with a 400 status' do
      expect(response.status).to eq 401
    end
  end
end
