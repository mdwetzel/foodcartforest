require 'spec_helper'

describe "Cart pages" do

	subject { page }

	describe "Index" do		
		before do
		
			5.times do
				Cart.create!(cart_attributes)
			end

			visit carts_path
		end

		it { should have_title("Carts") }
		it { should have_selector("h1", text: "#{Cart.count} Carts") }
		it { should have_link(Cart.first.name, href: cart_path(Cart.first)) }
		it { should have_text(Cart.first.description[0..25]) }

		describe "Clicking a cart link" do
			it "should redirect to the cart's show page" do
				click_link(Cart.first.name, href: cart_path(Cart.first))

				expect(current_path).to eq(cart_path(Cart.first))
			end
		end
	end

	describe "Show" do

		let(:cart) { Cart.create!(cart_attributes) }

		before do
			visit cart_path(cart)
		end

		it { should have_title(cart.name) }
		it { should have_selector("h1", cart.name) }
		it { should have_text(cart.description) }
	end

	describe "Edit" do

	end
end