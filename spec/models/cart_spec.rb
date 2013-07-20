require 'spec_helper'

describe Cart do
	
	before do
		@cart = Cart.new name: "XYZ Cart",
						 description: "XYZ Cart is an amazing cart off of XYZ Street."
	end

	subject { @cart }

	describe "When description is not present" do
		before { @cart.description = "" }
		it { should_not be_valid }
	end

	describe "When description is too short" do
		before { @cart.description = "*" * 24 }
		it { should_not be_valid }
	end

	describe "When description is too long" do
		before { @cart.description = "*" * 5001 }
		it { should_not be_valid }
	end
	
	describe "When name is not present" do
		before { @cart.name = "" }
		it { should_not be_valid }
	end

	describe "When name is too long" do
		before { @cart.name = "*" * 101 }
		it { should_not be_valid }
	end
end