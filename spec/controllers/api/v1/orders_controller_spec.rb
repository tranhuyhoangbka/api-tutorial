require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do
  describe "GET #index" do
    before do
      @current_user = FactoryGirl.create :user
      3.times{FactoryGirl.create :order, user: @current_user}
      request.headers["Authorization"] = @current_user.auth_token
      get :index, user_id: @current_user.id
    end

    let(:orders_response){JSON.parse(response.body, symbolize_names: true)}

    it "return three orders" do
      expect(orders_response.count).to eq 3
    end

    it{expect(response).to have_http_status 200}
  end

  describe "GET #show" do
  end

  describe "POST #create" do
  end
end
