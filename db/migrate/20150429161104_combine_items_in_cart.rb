class CombineItemsInCart < ActiveRecord::Migration
	def up
		# Reemplaza multiples items de un mismo producto en la carta por uno con una sola linea
		Cart.all.each do |cart|
			# Contamos el numero de cada producto en la carta
			sums = cart.line_items.group(:product_id).sum(:quantity)
			
			sums.each do |product_id, quantity|
				if quantity > 1
					# borra items individuales
					cart.line_items.where(product_id: product_id).delete_all

					# se reemplaza con un solo item
					item = cart.line_items.build(product_id: product_id)
					item.quantity = quantity
					item.save!
				end
			end
		end
	end

	def down
		# Separa items con cantidad mayor que uno en multiples items
		LineItem.where( "quantity > 1" ).each do |line_item|
			# agregamos items individuales
			line_item.quantity.times do
				LineItem.create cart_id: line_item.cart_id, product_id: line_item.product_id, quantity: 1
			end
			# se borra el item original
			line_item.destroy
		end
	end
end
