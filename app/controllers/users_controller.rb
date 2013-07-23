class UsersController < ApplicationController

  before_filter :authenticate_user!, except: [:show]
  before_filter :authenticate_admin!, except: [:show, :edit, :update]

  def index
    @users = User.all
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

  private

  def authenticate_admin!
    unless current_user && current_user.admin?
      redirect_to new_user_session_path, notice: "You need to sign in before continuing."
    end
  end
end
