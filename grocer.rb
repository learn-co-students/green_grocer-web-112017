require 'pry'
def consolidate_cart(cart)
  final_hash = {}
  cart.each do |item_hash|
    item_hash.each do |item_name, details|
      final_hash[item_name] = {}
      details.each do |detail, value|
        final_hash[item_name][detail] = value
      end
      final_hash[item_name][:count] = cart.count {|hash| hash.has_key?(item_name)}
    end
  end
  return final_hash
end

# {
#   "AVOCADO" => {:price => 3.0, :clearance => true, :count => 2},
#   "KALE"    => {:price => 3.0, :clearance => false, :count => 1}
# }

def apply_coupons(cart, coupons_array)
  final_hash = {}
  final_hash.merge!(cart)
  coupons_array.each do |coupon|
    if final_hash.keys.include?(coupon[:item]) && cart[coupon[:item]][:count] >= coupon[:num]
      final_hash[coupon[:item] + " W/COUPON"] = {
        price: coupon[:cost],
        clearance: cart[coupon[:item]][:clearance],
        count: cart[coupon[:item]][:count] / coupon[:num]
      }
      final_hash[coupon[:item]][:count] = cart[coupon[:item]][:count] % coupon[:num]
    end
  end
  return final_hash
end

# {
#   "AVOCADO" => {:price => 3.0, :clearance => true, :count => 1},
#   "KALE"    => {:price => 3.0, :clearance => false, :count => 1},
#   "AVOCADO W/COUPON" => {:price => 5.0, :clearance => true, :count => 1},
# }


def apply_clearance(cart)
  cart.each do |item, details|
    if cart[item][:clearance] == true
      cart[item][:price] -= cart[item][:price] * 0.20
    end
  end
  return cart
end

# {
#   "PEANUTBUTTER" => {:price => 2.40, :clearance => true,  :count => 2},
#   "KALE"         => {:price => 3.00, :clearance => false, :count => 3}
#   "SOY MILK"     => {:price => 3.60, :clearance => true,  :count => 1}
# }

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  total = 0
  cart.each do |item, details|
    total += cart[item][:price] * cart[item][:count]
  end
  if total > 100
    total -= (total * 0.10)
    return total
  else
    return total
  end
end
