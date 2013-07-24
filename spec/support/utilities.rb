def full_title(page_title)
	base_title = "Food Cart Forest"
	if page_title.blank?
		base_title
	else
		"#{page_title} | #{base_title}"
	end
end

def sign_in(user)
	visit new_user_session_path

	fill_in "Username", with: user.username
	fill_in "Password", with: user.password

	click_button "Sign in"
end