class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_with_token!

  respond_to :json

  def index
    respond_with current_user.orders
  end

  def show
    respond_with current_user.orders.find_by_id(params[:id])
  end

  def create
    order = current_user.orders.build
    order.build_placements_from_product_ids_and_quantity params[:order][:product_ids_and_quantity]
    if order.save
      order.reload
      #SendEmailConfirm.perform_async order.id
      render json: order, status: 201, location: [:api, current_user, order]
    else
      render json: order.errors, status: 422
    end
  end

  private
  def order_params
    params.require(:order).permit product_ids_and_quantity: []
  end
end
