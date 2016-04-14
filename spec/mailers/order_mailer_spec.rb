require "rails_helper"

RSpec.describe OrderMailer, type: :mailer do
  include Rails.application.routes.url_helpers

  describe ".send_confirmation" do
    before :all do
      @product1 = FactoryGirl.create :product
      @product2 = FactoryGirl.create :product
      @order = FactoryGirl.create :order, product_ids: [@product1.id, @product2.id]
      @user = @order.user
      @order_mailer = OrderMailer.send_confirmation @order.id
    end

    it "should be set to be deliverd to the user from the order passed in" do
      @order_mailer.should deliver_to @user.email
    end

    it "should be set to be send from hoangth92.nd@gmail.com" do
      @order_mailer.should deliver_from "hoangth92.nd@gmail.com"
    end

    it "should contain the user's message in the mail body" do
      @order_mailer.should have_body_text(/Order: ##{@order.id}/)
    end

    it "should have correct subject" do
      @order_mailer.should have_subject(/Order Confirmation/)
    end

    it "should have the products count" do
      @order_mailer.should have_body_text(/You ordered #{@order.products.count} products:/)
    end
  end
end
