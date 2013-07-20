def full_title(page_title)
	base_title = "Food Cart Forest"
	if page_title.blank?
		base_title
	else
		"#{page_title} | #{base_title}"
	end
end