module ApplicationHelper
	def full_title(page_title)
		base_title = "Food Cart Forest"
		if page_title.blank?
			base_title
		else
			"#{page_title} | #{base_title}"
		end
	end

	def posted(post)
		"Posted #{time_ago_in_words(post.created_at)} ago by  
				 #{link_to post.user.username, user_path(post.user)}".html_safe
	end

	def link_to_external(url)
      link_to(url, (/^http/.match(url) ? url : "http://#{url}"), target: "_blank")
    end
end
