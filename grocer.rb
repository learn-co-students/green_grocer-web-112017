require 'pry'
def consolidate_cart(cart)
  # code here
  new_hash = {}
  unique_items = cart.uniq
  unique_items.each do |item|
    item.each do |key,value|
      item["#{key}"][:count] = cart.count(item)
      #build new hash to avoid arrays
      new_hash.merge!(item)
    end
  end
  new_hash
end

def apply_coupons(cart, coupons)
  # code here

  coupons.each do |coupon|
      if cart.keys.include?(coupon[:item]) && cart["#{coupon[:item]}"][:count] >= coupon[:num]
        #subtract for # of items required for coupon
        cart[coupon[:item]][:count] -= coupon[:num]
        #insert new bundle with new key into cart
        if cart[coupon[:item] + " W/COUPON"] == nil
          cart[coupon[:item] + " W/COUPON"] = {
          price: coupon[:cost],
          clearance: cart[coupon[:item]][:clearance],
          count: 1}
        else
            cart[coupon[:item] + " W/COUPON"][:count] += 1
        end
      end
  end
  cart
end

def apply_clearance(cart)
  # code here
  cart.keys.each do |key|
    if cart[key][:clearance] == true
      cart[key][:price] = (cart[key][:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  #binding.pry
  cart = consolidate_cart(cart)
  #binding.pry
  apply_coupons(cart,coupons)
  apply_clearance(cart)
  #check if over $100
  sum = 0
  cart.each do |k,v|
    if v[:count] > 0
      sum += v[:price] * v[:count]
    end
  end
  #binding.pry
  if sum > 100
    sum = (sum*0.90).round(2)
  end
  sum
end
