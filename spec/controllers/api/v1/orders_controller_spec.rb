require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do
  describe "GET #index" do
    before do
      @current_user = FactoryGirl.create :user
      3.times{FactoryGirl.create :order, user: @current_user}
      request.headers["Authorization"] = @current_user.auth_token
      get :index, user_id: @current_user.id, format: :json
    end

    let(:orders_response){JSON.parse(response.body, symbolize_names: true)[:orders]}

    it "return three orders" do
      expect(orders_response.count).to eq 3
    end

    it{expect(response).to have_http_status 200}
  end

  describe "GET #show" do
    let(:current_user){FactoryGirl.create :user}

    before do
      @order = FactoryGirl.create :order, user: current_user
      request.headers["Authorization"] = current_user.auth_token
      get :show, user_id: current_user.id, id: @order.id, format: :json
    end

    let(:order_response) {JSON.parse(response.body, symbolize_names: true)[:order]}

    it "returns order record matching the id" do
      expect(order_response[:id]).to eq @order.id
    end

    it{expect(response).to have_http_status 200}
  end

  describe "POST #create" do
  end
end
