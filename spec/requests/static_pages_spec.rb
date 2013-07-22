require 'spec_helper'

describe "Static pages" do

	subject { page }

	describe "Home page" do
		
		before do

			User.create!(user_attributes(username: "TestTest", email: "example2@example.com"))

			5.times do |counter|
				cart = Cart.create!(cart_attributes(name: "Cart#{counter}"))
				cart.comments.create!(comment_attributes)
			end

			visit root_path
		end

		it { should have_title(full_title("")) }

		it { should have_selector("h2", text: "Latest comments") }
		it { should have_selector("footer", text: Comment.first.user.username) }
		#it { should have_selector("footer", text: Comment.first.created_at) }
		it { should have_text(Comment.first.body) }
		it { should have_link(Comment.first.cart.name, cart_path(Comment.first.cart)) }
		it { should have_link(Comment.first.user.username, user_path(Comment.first.user)) }

		describe "Clicking a latest comments cart name" do
			it "should redirect to the cart show page" do
				click_link(Comment.first.cart.name)
				expect(current_path).to eq(cart_path(Cart.first))
			end
		end	
	end
end