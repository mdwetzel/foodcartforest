require "spec_helper"

describe "Cart pages" do

	subject { page }

	let(:cart) { Cart.create!(cart_attributes) }
	let(:user) { User.create!(user_attributes(email: "user@example.org")) }
	let(:admin) { User.create!(user_attributes(admin: true, username: "Admin5", email: "Admin5@example.org")) }

	describe "Index" do	
		describe "Not logged in" do	
			before do
				@carts = []		
				5.times { @carts << Cart.create!(cart_attributes) }
				visit carts_path
			end

			it { should have_title("Carts") }
			it { should have_selector("h1", text: "#{@carts.count} Carts") }
			it { should have_link(@carts.first.name, href: cart_path(@carts.first)) }
			it { should_not have_link("Add New Cart", href: new_cart_path) }

			describe "Clicking a cart link" do
				it "should redirect to the cart's show page" do
					click_link(@carts.last.name, href: cart_path(@carts.last))
					expect(current_path).to eq(cart_path(@carts.last))
				end
			end
		end

		describe "As a logged in user" do
			before do
				sign_in user
				visit carts_path
			end

			it { should_not have_link("Add New Cart", href: new_cart_path) }
		end

		describe "As an admin user" do
			before do
				sign_in admin
				visit carts_path
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
		before do
			visit cart_path(cart)
		end

		describe "Not logged in" do
			it { should have_title(cart.name) }
			it { should have_selector("h1", cart.name) }

			it { should have_text(cart.description) }
			it { should have_text(cart.website) }
			it { should have_text(cart.twitter) }
			it { should have_text(cart.facebook) }
			it { should have_text(cart.phone) }
			it { should have_text(cart.location) }

			it { should_not have_selector("h2", text: "Add comment") }
			it { should_not have_selector("textarea") }

			it { should_not have_link("Edit Cart") }
			it { should_not have_link("Delete Cart") }

			it { should have_text("Sign in to add a comment!") }

			describe "With comments" do
				before do
					@comments = []
					10.times { @comments << cart.comments.create!(comment_attributes(user_id: user.id)) }
					# after changing the page, always revisit.
					visit cart_path(cart)
				end

				it { should have_link(@comments.last.user.username) }
				it { should have_selector("article", text: @comments.last.body) }
				it { should have_selector("article header a", text: @comments.last.user.username) }
				it { should have_selector("article", @comments.last.body) }
				it { should have_selector("legend", text: "#{@comments.count} Comments") }

				describe "Clicking a commenter's username" do
					it "should redirect to the user's show page" do
						click_link(@comments.first.user.username, match: :first)
						expect(current_path).to eq(user_path(@comments.first.user))
					end
				end
			end

			describe "Without comments" do
				before do
					visit cart_path(cart)
				end

				it { should have_text("No comments") }
				it { should have_selector("legend", text: "0 Comments") }
			end
		end

		describe "As a logged in user" do
			before do
				sign_in user
				visit cart_path(cart)
			end

			it { should have_selector("h2", text: "Add comment") }
			it { should have_selector("textarea") }

			describe "After having created a comment" do

				before do
					@user2 = User.create!(user_attributes(username: "User2", email: "user2@example.org"))
					@comment = user.comments.create(comment_attributes(cart_id: cart.id))
					@comment2 = @user2.comments.create(comment_attributes(cart_id: cart.id))
					visit cart_path(cart)
				end

				it "the user should be able to edit his own comment" do
					expect(page).to have_link("(Edit Comment)", href: edit_comment_path(@comment))

					click_link "(Edit Comment)"

					expect(current_path).to eq(edit_comment_path(@comment))
				end

				it "the user shouldn't be able to edit another user's comment" do
					expect(page).not_to have_link("(Edit Comment)", href: edit_comment_path(@comment2))
				end
			end

			describe "Clicking Create Comment" do
				before do
					visit cart_path(cart)
				end

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
			before do
				@comment = user.comments.create(comment_attributes(
					user_id: user.id,
					cart_id: cart.id))

				sign_in admin
				visit cart_path(cart)
			end

			it { should have_link("Edit Cart", href: edit_cart_path(cart)) }
			it { should have_link("Delete Cart"), href: cart_path(cart) }

			describe "When a user has created a comment" do
				it "the admin should be able to edit that comment" do
					expect(page).to have_link("(Edit Comment)", href: edit_comment_path(@comment))

					click_link "(Edit Comment)"

					expect(current_path).to eq(edit_comment_path(@comment))
				end
			end

			describe "Clicking delete" do
				it "should delete the cart" do
					expect {
						click_link "Delete"
					}.to change(Cart, :count).by(-1)

					expect(current_path).to eq(carts_path)
				end
			end	

			describe "Clicking edit" do
				it "should redirect to the edit cart page" do
					click_link "Edit", href: edit_cart_path(cart)

					expect(current_path).to eq(edit_cart_path(cart))
				end
			end
		end
	end

	describe "Edit" do
		describe "Not logged in" do
			before { visit edit_cart_path(cart) }
			it "should redirect to the login page" do
				expect(current_path).to eq(new_user_session_path)
			end
		end

		describe "As a logged in user" do
			before do
				sign_in user
				visit edit_cart_path(cart)
			end

			it "should redirect to the root path" do
				expect(current_path).to eq(root_path)
			end
		end

		describe "As an admin user" do
			before do
				sign_in admin
				visit edit_cart_path(cart)
			end

			it { should have_title("Edit #{cart.name}") }
			it { should have_selector("h1", text: "Edit #{cart.name}") }

			describe "Clicking 'update cart'" do
				it "should update the cart" do


					click_button "Update Cart"

					expect(current_path).to eq(cart_path(cart))

					expect(page).to have_text("Successfully updated cart!")

					
				end
			end

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
	end

	describe "New" do
		describe "Not logged in" do
			before { visit new_cart_path }
			it "should redirect to the login page" do
				expect(current_path).to eq(new_user_session_path)
			end
		end

		describe "As a logged in user" do
			before do
				sign_in user
				visit new_cart_path
			end

			it "should redirect to the root path" do
				expect(current_path).to eq(root_path)
			end
		end

		describe "As an admin user" do
			before do
				sign_in admin
				visit new_cart_path
			end

			it { should have_title("Add New Cart") }
			it { should have_selector("h1", "Add New Cart") }

			describe "Clicking 'create cart'" do
				it "should create the cart with valid data" do

					fill_in "Name", with: "ABC Cart"
					fill_in	"Description", with: "An amazing cart on ABC street."
					fill_in	"Location", with: "4920 ABC street"
					fill_in	"Phone", with: "(555) 555-5555"
					fill_in	"Website", with: "www.fakesite.com"
					fill_in	"Twitter", with: "www.faketwitter.com"
					fill_in	"Facebook", with: "www.fakefacebook.com"
					
					expect {
						click_button "Create Cart"
					}.to change(Cart, :count).by(1)

					expect(current_path).to eq(cart_path(Cart.last))
					expect(page).to have_text("Successfully created cart!")

					expect(page).to have_text("An amazing cart on ABC street.")
					expect(page).to have_text("(555) 555-5555")
					expect(page).to have_text("www.fakesite.com")
					expect(page).to have_text("www.faketwitter.com")
					expect(page).to have_text("4920 ABC street")
					expect(page).to have_text("www.fakefacebook.com")
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
end