require 'rails_helper'
require 'spec_helper'

describe 'update a user', type: :request do
  let(:user) { create :user }
  let(:update_params) { { user: { name: user.name, profile_picture_file_name: 'teste.jpg' } } }
  let(:token) { WebToken.encode(user) }
  let(:headers) { { 'ACCEPT': 'application/json', 'Authorization': "Bearer #{ token }" } }

  before do
    patch(
      "/v1/users/#{user.id}",
      params: update_params,
      headers: headers
    )
  end

  context 'request with user token' do
    context 'request params with profile_picture_file_name' do
      it 'presign_object hash should be nil' do
        expect(json['meta']['presign_object']).not_to be_nil
      end

      it 'returns user name' do
        expect(json['user']['name']).to eq(user.name)
      end

      it 'returns user email' do
        expect(json['user']['email']).to eq(user.email)
      end

      it 'returns user token' do
        expect(json['meta']['jwt']['token']).not_to be_empty
      end

      it 'returns user presign_object' do
        expect(json['meta']['presign_object']).not_to be_empty
      end

      it 'returns user presign_object' do
        expect(json['meta']['presign_object']['presigned_url']).not_to be_empty
      end

      it 'returns user public_url' do
        expect(json['meta']['presign_object']['public_url']).not_to be_empty
      end

      it 'responds with a 200 status' do
        expect(response.status).to eq 200
      end
    end

    context 'request params without profile_picture_file_name' do
      let(:update_params) { { user: { name: user.name } } }

      it 'presign_object hash should be nil' do
        expect(json['meta']['presign_object']).to be_nil
      end
    end
  end

  context 'request without user token' do
    let(:headers) { { 'ACCEPT': 'application/json' } }
    it 'responds with a 401 status' do
      expect(response.status).to eq 401
    end
  end

  context 'request with random user token (not the owner of the object)' do
    let(:random_user) { create :random_user }
    let(:token) { WebToken.encode(random_user) }
    let(:headers) { { 'ACCEPT': 'application/json', 'Authorization': "Bearer #{token}" } }

    it 'responds with a 401 status' do
      expect(response.status).to eq 401
    end
  end
end
