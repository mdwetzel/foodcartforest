module UsersHelper
	def avatar(user)
		if user.avatar.blank?
			image_tag('person.gif')
		else
			link_to(image_tag(user.avatar.url(:thumb)), user.avatar.url)
		end
	end
end
