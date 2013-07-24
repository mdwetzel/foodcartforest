require "spec_helper"

describe "User pages" do
	
	subject { page }

	let(:user) { User.create!(user_attributes) }
	let(:admin) { User.create!(user_attributes(username: "Blah", admin: true, email: "admin@example.434")) }

	describe "Index" do
		describe "Not logged in" do

			before { visit users_path }

			it "should redirect to the sign in page" do
				expect(current_path).to eq(new_user_session_path)
				expect(page).to have_text("You need to sign in")
			end
		end

		describe "As a logged in user" do

			before do
				sign_in user
				visit users_path
			end

			it "should redirect to the root path" do
				expect(current_path).to eq(root_path)
			end
		end

		describe "As an admin user" do

			before do
				sign_in admin
				visit users_path
			end

			it { should have_title("Users") }
			it { should have_selector("h1", text: "Users") }
			it { should have_link(User.first.username) }
			it { should have_selector("td", User.first.email) }
			it { should have_selector("td", User.first.created_at) }
			it { should have_selector("td", User.first.current_sign_in_ip) }
			it { should have_selector("td", User.first.current_sign_in_at) }
		end
	end

	describe "Show" do

		before do
			visit user_path(user)
		end

		it { should have_title(user.username) }
		it { should have_selector("h1", text: user.username) }
		it { should have_selector("th", text: "Comments") }
		it { should have_selector("td", text: user.comments.count) }
		it { should have_selector("th", text: "Registered") }
		it { should have_selector("td", text: user.created_at) }
		it { should have_selector("img[src$='person.gif']") }


		it { should_not have_link("Edit User") }
		it { should_not have_link("Delete User") }

		describe "As a logged in user" do
		
			before do
				sign_in user
				visit user_path(user)
				expect(current_path).to eq(user_path(user))	
			end

			it { should_not have_link("Edit User") }
			it { should_not have_link("Delete User") }
		end

		describe "As an admin user" do

			before do
				sign_in admin

				visit user_path(user)

				expect(current_path).to eq(user_path(user))
			end

			it { should have_link("Edit User") }
			it { should have_link("Delete User") }

			describe "Clicking 'edit user'" do
				it "should redirect to the edit user page" do
					click_link "Edit User"

					expect(current_path).to eq(edit_user_path(user))
				end
			end

			describe "Clicking 'delete user'" do
				it "should delete the user and redirect to the user index" do

					expect {
						click_link "Delete User"
					}.to change(User, :count).by(-1)

					expect(current_path).to eq(users_path)
					expect(page).to have_text("Successfully destroyed the user!")
				end
			end
		end
	end

	describe "Edit" do

		describe "As a logged in user" do
			before do
				sign_in user

				visit edit_user_path(user)
			end

			it { should have_title("Editing #{user.username}") }
			it { should have_selector("h1", text: "Editing #{user.username}") }
			it { should have_content("Username") }
			it { should have_content("Email") }

			describe "Clicking 'Update User'" do

				it "should update the user and display a success message" do

					click_button "Update User"

					expect(current_path).to eq(edit_user_path(user))
					expect(page).to have_content("Successfully updated settings.")
				end
			end
		end
		
		describe "As an admin user" do

			before do
				sign_in admin

				visit edit_user_path(user)

				expect(current_path).to eq(edit_user_path(user))
			end

			describe "Clicking 'delete user'" do
				it "should delete the user and redirect to the user index" do

					expect {
						click_link "Delete User"
					}.to change(User, :count).by(-1)

					expect(current_path).to eq(users_path)
					expect(page).to have_text("Successfully destroyed the user!")
				end
			end
		end
	end
end