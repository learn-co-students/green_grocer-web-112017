require "pry"
require "grocer_spec"

def consolidate_cart(cart)
  return_hash = {}
  #binding.pry
  cart.each do |element|
    element.each do |item, info_hash|
      if return_hash[item] == nil
        return_hash[item] = info_hash
        return_hash[item][:count] = 1
      else
        return_hash[item][:count] += 1
      end
    end
    #binding.pry
  end
  return_hash
end

def apply_coupons(cart, coupons)
  return_val = coupons.map do |hash|
      if cart[hash[:item]] != nil
        if cart[hash[:item]][:count] >= hash[:num] && cart["#{hash[:item]} W/COUPON"] == nil
          cart[hash[:item]][:count] -= hash[:num]
          cart["#{hash[:item]} W/COUPON"] = {:price => hash[:cost], :clearance => cart[hash[:item]][:clearance], :count => 1}
        elsif cart[hash[:item]][:count] >= hash[:num]
          cart[hash[:item]][:count] -= hash[:num]
          cart["#{hash[:item]} W/COUPON"][:count] += 1
        end
      end
  end
  cart
end

def apply_clearance(cart)
  cart.map do |item, hash|
    if hash[:clearance] == true
      newprice = (hash[:price] * 0.8).round(3)
      hash[:price] = newprice
    end
  end
  cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart,coupons)
  cart = apply_clearance(cart)
  sum = 0.0
  # if coupons == [find_coupon("AVOCADO"), find_coupon("CHEESE")]
  #   binding.pry
  # end
  cart.each do |item, hash|
    sum += hash[:price] * hash[:count]
  end
  if sum > 100
    new_sum = (sum* 0.9)
    sum = new_sum
  end

  sum
end
