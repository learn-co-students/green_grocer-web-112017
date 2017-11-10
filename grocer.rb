require 'pry'

def consolidate_cart(cart)
  result = {}
  cart.each do |item|
    item.each do |name, data|
      # data.each do |attribute, value|
        if !(result.keys.include?(name))
          result[name] = data
          result[name][:count] = 1
        else
          result[name][:count] += 1
        end
    end
  end
  result
end

def apply_coupons(cart, coupons)
  # code here
  # binding.pry
  result = {}
  cart.each do |item, data|
    # binding.pry
    result[item] = data
    coupons.each do |coupon|
      if coupon.values.include?(item) && data[:count] >= coupon[:num]
        if !(result.keys.include?((item + " W/COUPON")))
          result[(item + " W/COUPON")] = {price: (coupon[:cost]), clearance: (data[:clearance]), count: 1}
          result[item][:count] -= coupon[:num]
        else
          result[(item + " W/COUPON")][:count] += 1
          result[item][:count] -= coupon[:num]
        end
      end
    end
  end
  result
  # binding.pry
end

def apply_clearance(cart)
  # code here
  cart.each do |item, data|
    if data[:clearance] == true
      data[:price] = (data[:price]*0.8).round(2)
    end
  end
end

def checkout(cart, coupons)
  # code here
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = 0
  cart.each do |item, data|
    total += (data[:price]*data[:count])
  end
  if total > 100
    total = (total*0.9).round(2)
  end
  total
end
