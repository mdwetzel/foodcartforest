class CartsController < ApplicationController
  before_filter :authenticate_admin!, except: [:index, :show]

  def index
  	@carts = Cart.all
  end

  def show
  	@cart = Cart.find(params[:id])
  	@comments = @cart.comments
    @comment = Comment.new
  end

  def edit
  	@cart = Cart.find(params[:id])
  end

  def new
    @cart = Cart.new
  end

  def update
    @cart = Cart.find(params[:id])

    if @cart.update(cart_params)
      redirect_to @cart, notice: "Successfully updated cart!"
    else
      render :edit
    end 
  end

  def destroy
  	@cart = Cart.find(params[:id])
  	@cart.destroy
  	redirect_to carts_path, notice: "Successfully deleted cart!"
  end

  def create
    @cart = Cart.new(cart_params)

    if @cart.save
      redirect_to @cart, notice: "Successfully created cart!"
    else
      render :new
    end
  end

  def cart_params
    params.require(:cart).permit(:name, :description, :location,
                     :phone, :website, :twitter, :facebook)
  end
end
