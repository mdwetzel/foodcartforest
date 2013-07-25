require "spec_helper"

describe "Entry pages" do
	
	subject { page }

	let(:user) { User.create!(user_attributes) }
	let(:admin) { User.create!(user_attributes(admin: true, email: "Admin4@example.org", username: "Admin4")) }

	describe "Index" do
		describe "Not logged in" do
			before do
				@entries = []
				15.times do 
					@entries << Entry.create!(entry_attributes(user_id: user.id))
				end
				visit entries_path
			end

			it { should have_selector("article header h1 a", text: @entries.first.title) }
			it { should have_selector("article", text: @entries.first.body) }
			it { should have_selector("article footer small", text: @entries.first.user.username) }
			it { should have_link(@entries.first.title, entries_path(@entries.first)) }
			it { should have_link(@entries.first.user.username, user_path(@entries.first.user)) }
			it { should have_text("No comments yet.") } 
			it { should_not have_link("Create Entry", new_entry_path) }

			describe "Clicking an entry" do
				it "redirects to the entry's show page" do
					click_link(Entry.last.title, match: :first)
					expect(current_path).to eq(entry_path(Entry.last))
				end
			end

			describe "Clicking an entry's author" do
				it "redirects to the user's show page" do
					click_link(Entry.first.user.username, match: :first)
					expect(current_path).to eq(user_path(Entry.first.user))
				end
			end
		end

		describe "Logged in as an admin user" do
			before do
				sign_in admin
				visit entries_path
			end

			it { should have_link("Create Entry", new_entry_path) }
		end
	end

	describe "Manage" do
		before { visit manage_entries_path }

		describe "Not logged in" do
			it "should redirect to the login page" do
				expect(current_path).to eq(new_user_session_path)
			end
		end

		describe "Logged in as a user" do
			before do
				sign_in user
				visit manage_entries_path
			end

			it "should redirect to the login page" do
				expect(current_path).to eq(root_path)
			end
		end

		describe "As an admin user" do
			before do
				sign_in admin
				visit manage_entries_path
			end

			it { should have_title("Manage Entries") }
			it { should have_selector("h1", text: "Manage Entries") }
		end
	end

	describe "Show" do
		before do
			@entry = Entry.create!(entry_attributes(user_id: user.id))
			visit entry_path(@entry)
		end

		it { should have_title(@entry.title) }
		it { should have_selector("h1", @entry.title) }
		it { should have_text(@entry.body) }

		it { should_not have_link("Edit Entry", edit_entry_path(@entry)) }
		it { should_not have_link("Delete Entry", entry_path(@entry)) }

		describe "As a logged in user" do
			before do
				sign_in user
				visit entry_path(@entry)
			end

			it { should_not have_link("Edit Entry", edit_entry_path(@entry)) }
			it { should_not have_link("Delete Entry", entry_path(@entry)) }
		end

		describe "As an admin user" do
			before do
				sign_in admin
				visit entry_path(@entry)
			end

			it { should have_link("Edit Entry", edit_entry_path(@entry)) }
			it { should have_link("Delete Entry", entry_path(@entry)) }

			describe "Clicking 'edit entry'" do
				it "should redirect to the entry's edit page" do
					click_link "Edit Entry"
					expect(current_path).to eq(edit_entry_path(@entry))
				end
			end

			describe "Clicking 'delete entry'" do
				it "should delete the entry" do
					expect { 
						click_link "Delete Entry"
					}.to change(Entry, :count).by(-1)

					expect(current_path).to eq(entries_path)
					expect(page).to have_text("Successfully deleted entry!")
				end
			end
		end 
	end

	describe "New" do

		let(:entry) { Entry.create!(entry_attributes) }

		describe "Not logged in" do
			before { visit new_entry_path }

			it "should redirect to the sign in page" do
				expect(current_path).to eq(new_user_session_path)
			end
		end

		describe "As a logged in user" do
			before do
				sign_in user
				visit new_entry_path
			end
			
			it "should redirect to the root path" do
				expect(current_path).to eq(root_path)
			end
		end

		describe "As an admin user" do
			before do
				sign_in admin
				visit new_entry_path
			end

			it { should have_title("New Entry") }
			it { should have_selector("h1", text: "New Entry") }

			it "should create a new entry with valid information" do
				fill_in "Title", with: entry.title
				fill_in "Body", with: entry.body

				expect {
					click_button "Create Entry"
				}.to change(Entry, :count).by(1)

				expect(current_path).to eq(entry_path(Entry.last))
				expect(page).to have_text("Successfully created entry!")
			end

			it "should not create a new entry with invalid information" do
				expect {
					click_button "Create Entry"
				}.not_to change(Entry, :count)

				expect(page).to have_text("error")
			end
		end
	end

	describe "Edit" do
		
		let(:entry) { Entry.create!(entry_attributes) }

		describe "Not logged in" do
			before { visit edit_entry_path(entry) }

			it "should redirect to the sign in page" do
				expect(current_path).to eq(new_user_session_path)
			end
		end

		describe "As a logged in user" do
			before do
				sign_in user
				visit edit_entry_path(entry)
			end
			
			it "should redirect to the root path" do
				expect(current_path).to eq(root_path)
			end
		end

		describe "As an admin user" do
			before do
				sign_in admin
				visit edit_entry_path(entry)
			end

			it { should have_title("Edit Entry") }
			it { should have_selector("h1", text: "Edit Entry") }

			it "should edit the entry with valid information" do
				fill_in "Title", with: entry.title
				fill_in "Body", with: entry.body

				click_button "Update Entry"
				
				expect(current_path).to eq(entry_path(entry))
				expect(page).to have_text("Successfully updated entry!")

			end

			it "should not edit the entry with invalid information" do
				fill_in "Title", with: ""
				fill_in "Body", with: ""

				click_button "Update Entry"

				expect(page).to have_text("error")
			end
		end		
	end	
end