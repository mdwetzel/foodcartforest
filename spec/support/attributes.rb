def cart_attributes(overrides = {})
	{
		name: "XYZ Cart", 
		description: "An amazing cart on XYZ street.",
		location: "123 Street",
		phone: "(503)545-5454",
		website: "www.xyzcart.com",
		facebook: "facebook.com/xyzcart",
		twitter: "twitter.com/xyzcart"
	}.merge(overrides)
end

def comment_attributes(overrides = {})
	{
		user_id: 1,
		cart_id: 1,
		body: "This is a comment. " * 5
	}.merge(overrides)
end

def user_attributes(overrides = {})
	{
		username: "Example",
		email: "example@example.org",
		password: "password",
		admin: false
	}.merge(overrides)
end

def entry_attributes(overrides = {})
	{
		title: "This is a valid entry title",
		body: "This is the body for a valid entry. " * 5,
		user_id: 1
	}.merge(overrides)
end