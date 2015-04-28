class StoreController < ApplicationController
  def index
		@products = Product.order(:title)
		@count = increment_count_session
  end

	def increment_count_session
		if session[:counter].nil?
			session[:counter] = 0
		else
			session[:counter] += 1
		end
	end
end
