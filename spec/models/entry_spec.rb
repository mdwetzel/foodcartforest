require "spec_helper"

describe "Entry" do

	before do
		@entry = Entry.new(entry_attributes)
	end

	subject { @entry }

	describe "When user_id is not present" do
		before { @entry.user_id = nil }
		it { should_not be_valid }
	end

	describe "When title is not present" do
		before { @entry.title = "" }
		it { should_not be_valid }
	end

	describe "When title is too short" do
		before { @entry.title = "4" }
		it { should_not be_valid }
	end

	describe "When title is too long" do
		before { @entry.title = 101 }
		it { should_not be_valid }
	end

	describe "When body is too short" do
		before { @entry.body = 49 }
		it { should_not be_valid }
	end

	describe "When body is too long" do
		before { @entry.body = 10001 }
		it { should_not be_valid }
	end

	describe "When body is not present" do
		before { @entry.body = "" }
		it { should_not be_valid }
	end
end