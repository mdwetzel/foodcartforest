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
		it { should have_text(Cart.first.description[0..25]) }

		describe "Clicking a cart link" do
			it "should redirect to the cart's show page" do
				click_link(Cart.first.name, href: cart_path(Cart.first))

				expect(current_path).to eq(cart_path(Cart.first))
			end
		end
	end

	describe "Show" do

		let(:cart) { Cart.create!(cart_attributes) }

		before do
			User.create!(user_attributes)
			cart.comments.create!(comment_attributes(user_id: 1))

			visit cart_path(cart)
		end

		it { should have_title(cart.name) }
		it { should have_selector("h1", cart.name) }
		it { should have_text(cart.description) }

		it { should have_selector("h1", text: "Comments") }
		it { should have_text(cart.comments.first.body) }
		it { should have_text(cart.comments.first.created_at) }

		it { should_not have_link("Edit Cart") }
		it { should_not have_link("Delete Cart") }

		describe "With comments" do
			it { should have_selector("article", text: cart.comments.first.body) }
			it { should have_selector("article footer small", text: cart.comments.first.created_at) }
			it { should have_link(cart.comments.first.user.username) }
			it { should have_selector("article header a", text: cart.comments.first.user.username) }
		end

		describe "Without comments" do

			before do
				cart.comments.destroy_all

				visit cart_path(cart)
			end

			it { should have_text("No comments") }
		end

		describe "When not logged in" do
			it { should_not have_selector("h2", text: "Add comment") }
			it { should_not have_selector("textarea") }
		end

		describe "As a logged in user" do

			let(:user) { User.create!(user_attributes(email: "user@example.org")) }

			before do
				visit new_user_session_path
				fill_in "Email", with: user.email
				fill_in "Password", with: user.password

				click_button "Sign in"

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
				end
			end
		end

		describe "As an admin user" do

			let(:admin) { User.create!(user_attributes(admin: true, email: "admin@example.com")) }

			before do
				visit new_user_session_path
				fill_in "Email", with: admin.email
				fill_in "Password", with: admin.password

				click_button "Sign in"

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
					click_link "Edit"

					expect(current_path).to eq(edit_cart_path(cart))
				end
			end
		end
	end

	describe "Edit" do

		let(:cart) { Cart.create!(cart_attributes) }

		before do
			cart.comments.create!(comment_attributes)

			visit edit_cart_path(cart)
		end

		it { should have_selector("h1", text: "Edit #{cart.name}") }
	end
end