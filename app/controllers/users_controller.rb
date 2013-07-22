class UsersController < ApplicationController
  def index
  end

  def show
  	@user = User.find(params[:id])
  end

  def edit
  	@user = User.find(params[:id])
  end

  def update
  	@user = User.find(params[:id])

  	if @user.update(user_params)
  		redirect_to edit_user_path(@user), notice: "Successfully updated settings."
  	else
  		render :edit
  	end
  end

  def destroy
  	@user = User.find(params[:id])
  	@user.destroy
	  redirect_to users_path, notice: "Successfully destroyed the user!"
  end

  def user_params
  	params.require(:user).permit(:username, :email)
  end
end
