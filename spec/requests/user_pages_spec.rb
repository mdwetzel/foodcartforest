require "spec_helper"

describe "User pages" do
	
	subject { page }

	describe "Show" do

		let(:user) { User.create!(user_attributes) }

		before do
			visit user_path(user)
		end

		it { should have_title(user.username) }
		it { should have_selector("h1", text: user.username) }
		it { should have_content("Comments") }
		it { should have_selector("img[src$='person.gif']") }

		describe "As a logged in user" do
		
			before do
				visit new_user_session_path
				fill_in "Email", with: user.email
				fill_in "Password", with: user.password

				click_button "Sign in"

				visit user_path(user)

				expect(current_path).to eq(user_path(user))	
			end

			it { should_not have_link("Edit User") }
			it { should_not have_link("Delete User") }
		end

		describe "As an admin user" do
			let(:admin) { User.create!(user_attributes(admin: true, email: "admin@example.com")) }

			before do
				visit new_user_session_path
				fill_in "Email", with: admin.email
				fill_in "Password", with: admin.password

				click_button "Sign in"

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

		let(:user) { User.create!(user_attributes) }

		before do
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
		
		describe "As an admin user" do
			let(:admin) { User.create!(user_attributes(admin: true, email: "admin@example.com")) }

			before do
				visit new_user_session_path
				fill_in "Email", with: admin.email
				fill_in "Password", with: admin.password

				click_button "Sign in"

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