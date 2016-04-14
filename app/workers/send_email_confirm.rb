class SendEmailConfirm
  include Sidekiq::Worker

  def perform order_id
    OrderMailer.send_confirmation(order_id).deliver
  end
end
