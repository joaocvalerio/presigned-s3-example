require 'rails_helper'
require 'spec_helper'

describe 'register a user', type: :request do
  let(:user) { build :user }
  let(:register_params) { { name: user.name, email: user.email, password: user.password }  }
  let(:headers) { { 'ACCEPT': 'application/json' } }

  before do
    post(
      "/v1/users",
      params: register_params,
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
    let(:register_params) { { name: user.name, password: 12345678 }  }
    it 'responds with a 204 status (no content)' do
      expect(response.status).to eq 204
    end
  end
end
