require 'spec_helper'

describe "Static pages" do

	subject { page }

	describe "Home page" do
		
		before do
			visit root_path
		end

		it { should have_title(full_title("")) }
	end
end