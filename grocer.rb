def consolidate_cart(cart)
  consolidated = {}
  cart.each do |purchase|
    purchase.each do |vege,hash|
      if consolidated[vege] == nil
        consolidated[vege] = hash
        consolidated[vege][:count] = 0
      end
      consolidated[vege][:count] += 1
    end
  end
  return consolidated
end

def apply_coupons(cart, coupons)
  applied_cart = {}
  cart.each do |key , value|
    coupons.each do |coupon|
      if key.to_s == coupon[:item]
        coupon_key = "#{key.to_s} W/COUPON"
        if applied_cart[coupon_key] == nil
          applied_cart[coupon_key] = {
            :price =>  coupon[:cost],
            :clearance => value[:clearance],
            :count => 0
          }
        end
        if cart[key][:count] >= coupon[:num]
          applied_cart[coupon_key][:count] += 1
          cart[key][:count] -= coupon[:num]
        end
      end
    end
  end
  cart = cart.merge(applied_cart)
  return cart
end

def apply_clearance(cart)
  cart.each do |item, data|
    if data[:clearance] == true
      data[:price] = data[:price] - data[:price] *0.2
    end
  end
  cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart,coupons)
  cart = apply_clearance(cart)
  totals = cart.collect do |item, value|
    value[:price] * value[:count]
  end
  total = totals.reduce do |sum,val|
    sum += val
    sum
  end
  return total > 100 ? total - total * 0.1 : total
end
