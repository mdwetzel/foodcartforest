def cart_attributes(overrides = {})
	{
		name: "XYZ Cart", 
		description: "An amazing cart on XYZ street."
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
		email: "example@example.org",
		password: "password",
		admin: false
	}.merge(overrides)
end