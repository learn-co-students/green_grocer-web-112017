def consolidate_cart(cart)
  # code here
  consolidated = {}
  key = :count

  cart.each do |item|
    item.each do |name, details|

      if consolidated.has_key?(name) == false
        consolidated[name] = details
        consolidated[name][key] = 1
      else
        if consolidated.has_key?(name)
         consolidated[name][:count] += 1
        end
      end
    end
  end

  consolidated
end


def apply_coupons(cart, coupons)
  # code here
  coupons.each do |item|
    name_of_item = item[:item]
    if cart.has_key?(name_of_item) == true && cart[name_of_item][:count] >= item[:num]
      cart[name_of_item][:count] = cart[name_of_item][:count] - item[:num]
      new_item = name_of_item + (" W/COUPON")
      if cart.has_key?(new_item) == false
        cart[new_item] = {:price => item[:cost], :clearance => cart[name_of_item][:clearance], :count => 1}
      else
        cart[new_item][:count] += 1
      end
    end
  end
  cart
end

def apply_clearance(cart)
  # code here
  discount = 0.80
  cart.each do |item, details|
    if cart[item][:clearance] == true
      cart[item][:price] = (cart[item][:price]*discount).round(1)
    end
  end
  cart
end

def checkout(cart = [], coupons = [])
  # code here
  # code here
  total = 0
  cart = consolidate_cart(cart)

  if cart.length == 1
    cart = apply_coupons(cart, coupons)
    cart_clearance = apply_clearance(cart)
    if cart_clearance.length > 1
      cart_clearance.each do |item, details|
        if details[:count] >=1
          total += (details[:price]*details[:count])
        end
      end
    else
      cart_clearance.each do |item, details|
        total += (details[:price]*details[:count])
      end
    end
  else
    cart = apply_coupons(cart, coupons)
    cart_clearance = apply_clearance(cart)
    cart_clearance.each do |item, details|
      total += (details[:price]*details[:count])
    end
  end


  if total > 100
    total = total*(0.90)
  end
  total


end
