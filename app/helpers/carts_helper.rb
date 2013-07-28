module CartsHelper
	def cart_thumbnail(cart)
		if cart.cart_picture.blank?
			image_tag('person.gif')
		else
			link_to(image_tag(cart.cart_picture.url(:thumb)), cart)
		end
	end
end
