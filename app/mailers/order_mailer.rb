class OrderMailer < ApplicationMailer
  def send_confirmation order_id
    @order = Order.find_by_id order_id
    @user = @order.user
    mail to: @user.email, subject: "Order Confirmation"
  end
end
