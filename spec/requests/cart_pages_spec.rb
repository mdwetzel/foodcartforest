require 'spec_helper'

describe "Cart pages" do

	subject { page }

	describe "Index" do		
		before do
		
			5.times do
				Cart.create!(cart_attributes)
			end

			visit carts_path
		end

		it { should have_title("Carts") }
		it { should have_selector("h1", text: "#{Cart.count} Carts") }
		it { should have_link(Cart.first.name, href: cart_path(Cart.first)) }
		it { should_not have_link("Add New Cart", href: new_cart_path) }

		describe "Clicking a cart link" do
			it "should redirect to the cart's show page" do
				click_link(Cart.first.name, href: cart_path(Cart.first))

				expect(current_path).to eq(cart_path(Cart.first))
			end
		end

		describe "As an admin user" do

			let(:admin) { User.create!(user_attributes(admin: true, email: "admin@example.com")) }

			before do
				sign_in admin

				visit carts_path

				expect(current_path).to eq(carts_path)
			end

			it { should have_link("Add New Cart", href: new_cart_path) }

			describe "Clicking 'add new cart'" do
				it "should redirect to the add new cart page" do
					click_link "Add New Cart"

					expect(current_path).to eq(new_cart_path)
				end
			end
		end
	end

	describe "Show" do

		let(:cart) { Cart.create!(cart_attributes) }

		before do
			User.create!(user_attributes)
			cart.comments.create!(comment_attributes)

			visit cart_path(cart)
		end

		it { should have_title(cart.name) }
		it { should have_selector("h1", cart.name) }
		it { should have_text(cart.description) }
		it { should have_text(cart.website) }
		it { should have_text(cart.twitter) }
		it { should have_text(cart.facebook) }
		it { should have_text(cart.phone) }
		it { should have_text(cart.location) }

		it { should have_selector("legend", text: "1 Comment") }
		it { should have_text(cart.comments.first.body) }

		it { should_not have_link("Edit Cart") }
		it { should_not have_link("Delete Cart") }

		it { should have_text("Sign in to add a comment!") }

		describe "With comments" do
			it { should have_selector("article", text: cart.comments.first.body) }
			it { should have_link(cart.comments.first.user.username) }
			it { should have_selector("article header a", text: cart.comments.first.user.username) }
			it { should have_selector("article", cart.comments.first.body) }

			describe "Clicking a commentor's username" do
				it "should redirect to the user's show page" do
					click_link(Comment.first.user.username, match: :first)

					expect(current_path).to eq(user_path(Comment.first.user))
				end
			end

			describe "With two comments" do
				before do
					cart.comments.create!(comment_attributes) 
					visit cart_path(cart)
				end

				it { should have_selector("legend", text: "2 Comments") }
			end
		end

		describe "Without comments" do

			before do
				cart.comments.destroy_all

				visit cart_path(cart)
			end

			it { should have_text("No comments") }
			it { should have_selector("legend", text: "0 Comments") }
		end

		describe "When not logged in" do
			it { should_not have_selector("h2", text: "Add comment") }
			it { should_not have_selector("textarea") }
		end

		describe "As a logged in user" do

			let(:user) { User.create!(user_attributes(email: "user@example.org")) }

			before do
				sign_in user

				visit cart_path(cart)

				expect(current_path).to eq(cart_path(cart))		
			end

			it { should have_selector("h2", text: "Add comment") }
			it { should have_selector("textarea") }

			describe "Clicking Create Comment" do
				before { visit cart_path(cart) }

				it "should create the comment with valid data" do
					fill_in "Body", with: "This is a sample comment" * 5

					expect { 
						click_button "Create Comment"
					}.to change(Comment, :count).by(1)

					expect(current_path).to eq(cart_path(cart))
					expect(page).to have_text("Successfully added comment!")
				end

				it "should not create the comment with invalid data" do
					expect {
						click_button "Create Comment"
					}.not_to change(Comment, :count)

					expect(page).to have_text("error") 
				end
			end
		end

		describe "As an admin user" do

			let(:admin) { User.create!(user_attributes(username: "fwfwf", admin: true, email: "adminfff@example.com")) }

			before do
				sign_in admin

				visit cart_path(cart)

				expect(current_path).to eq(cart_path(cart))
			end

			it { should have_link("Edit Cart", href: edit_cart_path(cart)) }
			it { should have_link("Delete Cart"), href: cart_path(cart) }

			describe "Clicking delete" do
				it "should delete the cart" do
					expect {
						click_link "Delete"
					}.to change(Cart, :count).by(-1)

					expect(current_path).to eq(carts_path)
				end
			end	

			describe "Clicking edit" do
				it "should go to the edit cart page" do
					click_link "Edit", href: edit_cart_path(cart)

					expect(current_path).to eq(edit_cart_path(cart))
				end
			end
		end
	end

	describe "Edit" do

		let(:cart) { Cart.create!(cart_attributes) }

		let(:admin) { User.create!(user_attributes(username: "dqwdqwd", admin: true,
													 email: "adqwdqwd@wfr.com")) }

		before do
			sign_in admin

			visit edit_cart_path(cart)

			expect(current_path).to eq(edit_cart_path(cart))		
		end

		it { should have_title("Edit #{cart.name}") }
		it { should have_selector("h1", text: "Edit #{cart.name}") }

		describe "Clicking 'delete cart'" do
			it "should delete the cart" do
				expect {
					click_link "Delete Cart"
				}.to change(Cart, :count).by(-1)

				expect(current_path).to eq(carts_path)
				expect(page).to have_text("Successfully deleted cart!")
			end
		end
	end

	describe "New" do
		before do
			visit new_cart_path
		end

		it { should have_title("Add New Cart") }
		it { should have_selector("h1", "Add New Cart") }

		describe "Clicking 'create cart'" do
			it "should create the cart with valid data" do
				fill_in "Name", with: "XYZ Cart"
				fill_in "Description", with: "This is a valid description" * 10
				
				expect {
					click_button "Create Cart"
				}.to change(Cart, :count).by(1)

				expect(current_path).to eq(cart_path(Cart.last))
				expect(page).to have_text("Successfully created cart!")
			end

			it "should not create the cart with invalid data" do
				expect {
					click_button "Create Cart"
				}.not_to change(Cart, :count)

				expect(page).to have_text("error")
			end
		end
	end
end