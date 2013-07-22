class EntriesController < ApplicationController

	before_filter :authenticate_user!, except: [:index, :show]

	def index
		@entries = Entry.paginate	per_page: 10,
									page: params[:page],
									order: 'created_at desc'

		@latest_comments = Comment.order("created_at desc").limit(5)
	end

	def show
		@entry = Entry.find(params[:id])
	end

	def destroy
		@entry = Entry.find(params[:id])
		@entry.destroy
		redirect_to entries_path, notice: "Successfully deleted entry!"
	end

	def edit
		@entry = Entry.find(params[:id])
	end

	def update
		@entry = Entry.find(params[:id])

		if @entry.update(entry_params)
			redirect_to @entry, notice: "Successfully updated entry!"
		else
			render :edit
		end
	end

	def create
		@entry = Entry.new(entry_params)

		if @entry.save
			redirect_to @entry, notice: "Successfully created entry!"
		else
			render :new
		end
	end

	def new
		@entry = Entry.new
	end

	def entry_params
		params.require(:entry).permit(:title, :body, :user_id)
	end
end
