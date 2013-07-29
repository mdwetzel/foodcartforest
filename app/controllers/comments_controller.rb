class CommentsController < ApplicationController

	before_filter :correct_user, except: [:create]

	def create
		@comment = Comment.new(comment_params)
		@cart = @comment.cart
		@comments = @cart.comments

		if @comment.save
			redirect_to @cart, notice: "Successfully added comment!"
		else
			render 'carts/show'
		end
	end

	def edit
		@comment = Comment.find(params[:id])
	end

	def comment_params
		params.require(:comment).permit(:body, :cart_id, :user_id)
	end

	def correct_user
		if params[:id]
			@comment = Comment.find(params[:id])

			if user_signed_in?
				unless current_user == @comment.user || current_user.admin?
					redirect_to root_path
				end
			else
				redirect_to new_user_session_path
			end
		else
			redirect_to root_path
		end
	end
end
