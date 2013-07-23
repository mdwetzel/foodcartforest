require "spec_helper"

describe "Entry pages" do
	
	subject { page }

				let(:admin) { User.create!(user_attributes(admin: true, email: "admin@example.com")) }


	describe "Index" do

		before do

			User.create!(user_attributes)

			11.times do 
				Entry.create!(entry_attributes)
			end

			visit entries_path
		end

		it { should have_selector("article header h1", text: Entry.first.title) }
		it { should have_selector("article", text: Entry.first.body) }
		it { should have_selector("article footer small", text: Entry.first.created_at) }
		it { should have_selector("article footer small", text: Entry.first.user.username) }
		it { should have_link(Entry.first.title, entry_path(Entry.first)) }
		it { should have_link(Entry.first.user.username, user_path(Entry.first.user)) }

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

	describe "Show" do

		User.create!(user_attributes)

		before do
			@entry = Entry.create!(entry_attributes)
			visit entry_path(@entry)
		end

		it { should have_title(@entry.title) }
		it { should have_selector("h1", @entry.title) }
		it { should have_text(@entry.body) }
		it { should have_selector("footer", @entry.created_at) }

		describe "As an admin user" do
			before do
				visit new_user_session_path
				fill_in "Email", with: admin.email
				fill_in "Password", with: admin.password
				click_button "Sign in"
				visit entry_path(@entry)
				expect(current_path).to eq(entry_path(@entry))
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

		before do

			visit new_user_session_path
			fill_in "Email", with: admin.email
			fill_in "Password", with: admin.password

			click_button "Sign in"

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

	describe "Edit" do
		
		let(:entry) { Entry.create!(entry_attributes) }

		before do
			visit new_user_session_path
			fill_in "Email", with: admin.email
			fill_in "Password", with: admin.password

			click_button "Sign in"

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

		end
	end	
end