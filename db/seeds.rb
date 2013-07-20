def cart_attributes(overrides = {})
	{
		name: "XYZ Cart", 
		description: "An amazing cart on XYZ street."
	}.merge(overrides)
end

10.times do 
	Cart.create!(cart_attributes)
end