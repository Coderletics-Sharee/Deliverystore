class CartsController < ApplicationController
   before_action :authenticate_user!
 
  def show
    @cart_deliveries = current_user.get_cart_deliveries
  end
 
  def add
    $redis.sadd current_user_cart, params[:delivery_id]
    render json: current_user.cart_count, status: 200
  end

  def remove
    $redis.srem current_user_cart, params[:delivery_id]
    render json: current_user.cart_count, status: 200
  end
 
  private
 
  def current_user_cart
    "cart#{current_user.id}"
  end
end

