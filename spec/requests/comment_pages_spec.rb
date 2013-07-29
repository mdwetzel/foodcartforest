require 'spec_helper'

describe "Comment pages" do

	subject { page }

	let(:cart) { Cart.create!(cart_attributes) }
	let(:user) { User.create!(user_attributes(email: "user@example.org")) }
	let(:admin) { User.create!(user_attributes(admin: true, username: "Admin5", email: "Admin5@example.org")) }

	describe "Edit" do
		before do
			@comment = user.comments.create(comment_attributes(cart_id: cart.id))
			visit edit_comment_path(@comment)
		end

		describe "Not logged in" do
			it "should redirect to the login page" do
				expect(current_path).to eq(new_user_session_path)
			end
		end

		describe "As the user who authored the comment" do
			
		end

		describe "As a user who didn't author the comment" do
			before do
				@comment = user.comments.create!(comment_attributes)
				@wrongUser = User.create!(user_attributes(username: "Wrong", email: "wrong.user@example.org"))
				sign_in @wrongUser
				visit edit_comment_path(@comment)
			end

			describe "trying to edit the comment" do
				it "should redirect to the root path" do
					expect(current_path).to eq(root_path)
				end
			end
		end

		describe "As an admin user" do

		end
	end	
end