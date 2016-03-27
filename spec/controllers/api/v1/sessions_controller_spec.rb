require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  before(:each){request.headers['Accept'] = "application/vnd.marketplace.v1"}

  describe "POST #create" do

   before(:each) do
    @user = FactoryGirl.create :user
   end

    context "when the credentials are correct" do

      before(:each) do
        credentials = { email: @user.email, password: "12345678" }
        post :create, { session: credentials }, format: :json
      end

      it "returns the user record corresponding to the given credentials" do
        @user.reload
        expect(JSON.parse(response.body, symbolize_names: true)[:auth_token]).to eql @user.auth_token
      end

    end

    context "when the credentials are incorrect" do

      before(:each) do
        credentials = { email: @user.email, password: "invalidpassword" }
        post :create, { session: credentials }, format: :json
      end

      it "returns a json with an error" do
        expect(JSON.parse(response.body, symbolize_names: true)[:errors]).to eql "Invalid email or password"
      end

    end
  end

  describe "DELETE #destroy" do
    before do
      @user = FactoryGirl.create :user
      sign_in @user, store: false
      delete :destroy, id: @user.auth_token
    end
    it {expect(response).to have_http_status 204}
  end
end
