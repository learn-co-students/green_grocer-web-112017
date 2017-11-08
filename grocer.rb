require "pry"

def consolidate_cart(cart)
  basket = {}
  cart.each do |groceries|
    groceries.each do |product, stats|
      if basket[product]
        basket[product][:count] += 1
      else
        stats[:count] = 1
        basket[product] = stats
      end
    end
  end
  basket
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.keys.include?(coupon[:item])
      product = coupon[:item]
      num = coupon[:num]
      if cart[product][:count] >= num
        if cart["#{product} W/COUPON"]
          cart["#{product} W/COUPON"][:count] += 1
        else
          cart["#{product} W/COUPON"] = {:price => coupon[:cost], :clearance => cart[product][:clearance], :count => 1}
        end
        cart[product][:count] -= num
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |product, stats|
    if cart[product][:clearance]
      cart[product][:price] = (cart[product][:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  new_cart = consolidate_cart(cart)
  apply_coupons(new_cart, coupons)
  apply_clearance(new_cart)
  total_price = 0
  new_cart.each do |product, stats|
    total_price += stats[:price] * stats[:count]
  end
  if total_price > 100
    total_price *= 0.9
  end
  total_price.round(2)
end
