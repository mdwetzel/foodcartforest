class CommentsController < ApplicationController
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

	def comment_params
		params.require(:comment).permit(:body, :cart_id, :user_id)
	end
end
