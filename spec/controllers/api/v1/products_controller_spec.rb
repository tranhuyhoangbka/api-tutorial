require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  describe "GET #show" do
    before do
      @product = FactoryGirl.create :product
      get :show, id: @product.id, format: :json
    end

    let(:product_response){JSON.parse(response.body, symbolize_names: true)}
    subject{product_response[:title]}

    it "return json represent product" do
      is_expected.to eq @product.title
    end

    it{expect(response).to have_http_status 200}
  end

  describe "GET #index" do
    before do
      3.times{FactoryGirl.create :product}
      get :index, format: :json
    end

    let(:products_response){JSON.parse(response.body, symbolize_names: true)}

    it "return json represent for 3 products" do
      expect(products_response.count).to eq 3
    end
  end

  describe "POST #create" do
    context "when creating product is successfully" do
      before do
        user = FactoryGirl.create :user
        @product_attrs = FactoryGirl.attributes_for :product
        request.headers["Authorization"] = user.auth_token
        post :create, {user_id: user.id, product: @product_attrs}, format: :json
      end

      let(:product_response){JSON.parse(response.body, symbolize_names: true)}
      subject{product_response[:title]}

      describe "render json presentation for created product" do
        it{is_expected.to eq @product_attrs[:title]}
      end

      it{expect(response).to have_http_status 201}
    end

    context "when product is not created" do
      before do
        user = FactoryGirl.create :user
        product_attrs = {title: "T-shirt Duck", price: "fails price"}
        request.headers["Authorization"] = user.auth_token
        post :create, {user_id: user.id, product: product_attrs}, format: :json
      end

      let(:product_response){JSON.parse(response.body, symbolize_names: true)}

      describe "render error json object " do
        it do
          expect(product_response).to have_key :errors
        end
        it{expect(product_response[:errors][:price]).to include "is not a number"}
        it{expect(response).to have_http_status 422}
      end
    end
  end

  describe "PATCH #update" do
    let(:user){FactoryGirl.create :user}
    let(:product){FactoryGirl.create :product, user: user}
    before do
      request.headers["Authorization"] = user.auth_token
    end
    context "when update product successfully" do
      before do
        patch :update, {user_id: user.id, id: product.id, product: {title: "Wonderful Pan"}}, format: :json
      end

      let(:product_request){JSON.parse(response.body, symbolize_names: true)}

      it "has a new title" do
        expect(product_request[:title]).to eq "Wonderful Pan"
      end

      it{expect(response).to have_http_status 200}
    end

    context "when product is not updated" do
      before do
        patch :update, {user_id: user.id, id: product.id, product: {price: "fail price"}}, format: :json
      end

      let(:product_response){JSON.parse(response.body, symbolize_names: true)}

      it "render error json object" do
        expect(product_response).to have_key :errors
      end

      it "render message why fails" do
        expect(product_response[:errors][:price]).to include "is not a number"
      end

      it{expect(response).to have_http_status 422}
    end
  end

  describe "DELETE #destroy" do
    let(:user){FactoryGirl.create :user}
    let(:product){FactoryGirl.create :product, user: user}
    before do
      request.headers["Authorization"] = user.auth_token
    end
    let(:product_id){product.id}
    before do
      delete :destroy, {user_id: user.id, id: product.id}, format: :json
    end
    describe "not exists this product" do
      it{expect{Product.find(product_id)}.to raise_error ActiveRecord::RecordNotFound}
    end
    it{expect(response).to have_http_status 204}
  end
end
