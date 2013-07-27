class EntryCommentsController < ApplicationController
  def create
    @entry_comment = EntryComment.new(entry_comment_params)
    @entry = @entry_comment.entry
    @comments = @entry.entry_comments

    if @entry_comment.save
      redirect_to @entry_comment.entry, notice: "Successfully created comment!"
    else
      render "entries/show"
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def entry_comment_params
    params.require(:entry_comment).permit(:user_id, :entry_id, :body)
  end
end
