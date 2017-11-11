require_relative 'grocer'

def items
	[
		{"AVOCADO" => {:price => 3.00, :clearance => true}},
		{"KALE" => {:price => 3.00, :clearance => false}},
		{"BLACK_BEANS" => {:price => 2.50, :clearance => false}},
		{"ALMONDS" => {:price => 9.00, :clearance => false}},
		{"TEMPEH" => {:price => 3.00, :clearance => true}},
		{"CHEESE" => {:price => 6.50, :clearance => false}},
		{"BEER" => {:price => 13.00, :clearance => false}},
		{"PEANUTBUTTER" => {:price => 3.00, :clearance => true}},
		{"BEETS" => {:price => 2.50, :clearance => false}}
	]
end

def coupons
	[
		{:item => "AVOCADO", :num => 2, :cost => 5.00},
		{:item => "BEER", :num => 2, :cost => 20.00},
		{:item => "CHEESE", :num => 3, :cost => 15.00}
	]
end

def generate_cart
	[].tap do |cart|
		rand(20).times do
			cart.push(items.sample)
		end
	end
end

def generate_coupons
	[].tap do |c|
		rand(2).times do
			c.push(coupons.sample)
		end
	end
end

cart = generate_cart
coupons = generate_coupons

puts "Items in cart"
cart.each do |item|
	puts "Item: #{item.keys.first}"
	puts "Price: #{item[item.keys.first][:price]}"
	puts "Clearance: #{item[item.keys.first][:clearance]}"
	puts "=" * 10
end

puts "Coupons on hand"
coupons.each do |coupon|
	puts "Get #{coupon[:item].capitalize} for #{coupon[:cost]} when you by #{coupon[:num]}"
end

puts "Your total is #{checkout(cart: cart, coupons: coupons)}"

def consolidate_cart(array)
	consolidated_hash = {}
	array.map do |element|
		element.map do |item, info|
				consolidated_hash[item] = info
		end
	end
	return consolidated_hash

	i = 0
	while i < array.length
		count = array.count(array[i])
		consolidated_hash[array[i].keys.join][:count] = count
		i += 1
	end

	return consolidated_hash
end

# def consolidate_cart(array)
# 		consolidated_hash = {}
#
# 		array.map do |element|
# 			element.map do |item, info|
# 					consolidated_hash[item] = info
# 			end
# 		end
#
# 		consolidated_hash.map do |k, v|
# 			consolidated_hash[k][:count] = array.count(k=>v)
# 		end
#
# 		return consolidated_hash
# end
