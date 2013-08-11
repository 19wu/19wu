class UserOrdersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @orders = current_user.orders
  end
end
