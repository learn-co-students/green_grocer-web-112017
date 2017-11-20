require "pry"

def consolidate_cart(cart)
  cons_cart = {}
  cart.each do |item_hash|
    item_hash.each do |k,v|
      if cons_cart[k]
        cons_cart[k][:count] += 1
      else
        cons_cart[k] = v
        cons_cart[k][:count] = 1
      end
    end
  end
  cons_cart
end

def apply_coupons(cart, coups_array = nil)
  coups_array.each do |coupon_hash|
    test_item = coupon_hash[:item]
    if cart[test_item] && cart[test_item][:count] >= coupon_hash[:num]
      cart[test_item][:count] -= coupon_hash[:num]
      if cart[test_item + " W/COUPON"]
        cart[test_item + " W/COUPON"][:count] += 1
      else
        cart["#{test_item} W/COUPON"] = { :price => coupon_hash[:cost], :clearance => cart[test_item][:clearance], :count => 1 }
      end
    else
      return cart
    end
  end
  return cart
end

def apply_clearance(cart)
  cart.each do |item, item_hash|
    if item_hash[:clearance] == true
      item_hash[:price] = (item_hash[:price] * 0.8).round(1)
    end
  end
  return cart
end


def checkout(cart, coupons)
  subtotal1 = consolidate_cart(cart)
  subtotal2 = apply_coupons(subtotal1, coupons)
  subtotal3 = apply_clearance(subtotal2)
  total = 0
  subtotal3.each do |item, item_hash|
    total += (item_hash[:price] * item_hash[:count]).round(1)
  end
  total > 100? (total*0.9).round(1) : total
end

#cart = {
#  "AVOCADO" => {:price => 3.0, :clearance => true, :count => 3},
#  "KALE"    => {:price => 3.0, :clearance => false, :count => 1}
#}

#coupon = [{:item => "AVOCADO", :num => 2, :cost => 5.0}]
