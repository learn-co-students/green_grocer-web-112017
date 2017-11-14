
def consolidate_cart(cart)
    output = {}
    cart.each {|item|
        item.each {|key, values|
            item[key][:count] = 1}
    }
    cart.each do |h|
        h.each do |key, values|
                if output.has_key?(key)
                    output[key][:count] += 1
                else
                    output[key] = values
                end
            end
        end
    output
end

def apply_coupons(cart, coupons = nil)
  if coupons == nil || coupons == "" || coupons == []
     cart
  else
    output_a = {}
    output_b = {}
    cart.each do |key, values|
        initial_count = values[:count]
        coupons.each do |hash|
        remaining_count = initial_count % hash[:num]
        if key == hash[:item] && initial_count >= hash[:num]
            values[:count] = remaining_count
            output_a[key] = values
            coupon_count = (initial_count - remaining_count) / hash[:num]
            output_b["#{key} W/COUPON"] = {:price => hash[:cost], :clearance => values[:clearance], :count => coupon_count}
        else
           output_a[key] = values
    end
    end
 end
    output_a.merge(output_b)
end
end

def apply_clearance(cart)
    cart.each do |key, values|
        if values[:clearance] == true
            discount = 0.2
            adjusted_price = values[:price] * (1 - discount)
            values[:price] = adjusted_price.round(2)
        end
    end
end


def apply_clearance_to_all(cart)
    cart.each do |key, values|
        discount = 0.1
        adjusted_price = values[:price] * (1 - discount)
        values[:price] = adjusted_price.round(2)
    end
end


def checkout(cart, coupons)
  cons_cart = consolidate_cart(cart)
  post_coupons = apply_coupons(cons_cart, coupons)
  post_clearance = apply_clearance(post_coupons)
  
  prelim_costs = []
  post_clearance.each do |key, values|
      prelim_costs << (values[:price] * values[:count])
     end
  prelim_total = prelim_costs.map(&:to_f).reduce(0, :+)
  if prelim_total > 100
      final_cart = apply_clearance_to_all(post_clearance)
      final_costs = []
      final_cart.each do |key, values|
          final_costs << (values[:price] * values[:count])
      end
      final_total = final_costs.map(&:to_f).reduce(0, :+)
   else
     prelim_total
end
end

