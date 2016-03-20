require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before(:each){request.headers['Accept'] = "application/vnd.marketplace.v1"}

  describe "GET #show" do
    before do
      @user = FactoryGirl.create :user
      get :show, id: @user.id, format: :json
    end
    it "returns the information about a reporter on a hash" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql @user.email
    end
  end

  describe "POST #create" do
    context "when is successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, {user: @user_attributes}, format: :json
      end

      it "renders the json representation for for the user record just created" do
        user_response = JSON.parse response.body, symbolize_names: true
        expect(user_response[:email]).to eq @user_attributes[:email]
      end
    end

    context "when is not created" do
      before do
        @invalid_user_attributes = {password: "12345678", password_confirmation: "12345678"}
        post :create, {user: @invalid_user_attributes}, format: :json
      end
      let(:user_response){JSON.parse response.body, symbolize_names: true}
      it "renders an errors json" do
        expect(user_response).to have_key(:errors)
      end
      it "renders the json errors on why the user could not be created" do
        expect(user_response[:errors][:email]).to include "can't be blank"
      end
    end
  end

  describe "PUT/PATCH #update" do
    context "when is successfully updated" do
      before do
        @user = FactoryGirl.create :user
        patch :update, {id: @user.id, user: {email: "newmail@example.com"}}, format: :json
      end
      it "renders the json representation for the updated user" do
        user_response = JSON.parse response.body, symbolize_names: true
        expect(user_response[:email]).to eq "newmail@example.com"
      end
    end

    context "renders an errors json" do
      before do
        @user = FactoryGirl.create :user
        patch :update, {id: @user.id, user: {email: "babemail.com"}}, format: :json
      end
      let(:user_response){JSON.parse response.body, symbolize_names: true}
      it "renders an errors json" do
        expect(user_response).to have_key :errors
      end
      it "renders the json errors on why the user could not be created" do
        expect(user_response[:errors][:email]).to include "is invalid"
      end
    end
  end
end
