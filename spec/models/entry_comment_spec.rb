require 'spec_helper'

describe EntryComment do
	
	before do
		@entry_comment = EntryComment.new(entry_comment_attributes)
	end

	subject { @entry_comment }

	describe "When user_id is not present" do
		before { @entry_comment.user_id = nil }
		it { should_not be_valid }
	end

	describe "When entry_id is not present" do
		before { @entry_comment.entry_id = nil }
		it { should_not be_valid }
	end

	describe "When body is not present" do
		before { @entry_comment.body = "" }
		it { should_not be_valid }
	end

	describe "When entry_comment is too short" do
		before { @entry_comment.body = "*" * 49 }
		it { should_not be_valid }
	end

	describe "When entry_comment is too long" do
		before { @entry_comment.body = "*" * 1001 }
		it { should_not be_valid }
	end
end