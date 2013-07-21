require 'spec_helper'

describe Comment do
	before do
		@comment = Comment.new(comment_attributes)
	end

	subject { @comment }

	describe "When user_id is not present" do
		before { @comment.user_id = nil }
		it { should_not be_valid }
	end

	describe "When cart_id is not present" do
		before { @comment.cart_id = nil }
		it { should_not be_valid }
	end

	describe "When body is not present" do
		before { @comment.body = "" }
		it { should_not be_valid }
	end

	describe "When comment is too short" do
		before { @comment.body = "*" * 49 }
		it { should_not be_valid }
	end

	describe "When comment is too long" do
		before { @comment.body = "*" * 1001 }
		it { should_not be_valid }
	end
end