class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
      render json: items
    else
      items = Item.all
      render json: items, include: :user
    end
  end

  def show
    item = Item.find(params[:id])
    render json: item 
  end

  def create
    if params[:user_id]
      user = User.find(params[:user_id])
      item = user.items.create(item_params)
    else
      item = Item.create(item_params)
    end
    render json: item, status: :created
  end

  private

  def render_not_found_response
    render json: { error: "Review not found" }, status: :not_found
  end

  def item_params
    params.permit(:name, :description, :price)
  end

end
