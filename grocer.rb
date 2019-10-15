CLEARANCE_DISCOUNT = 0.20
VOLUME_DISCOUNT = 0.10

def find_item_by_name_in_collection(name, collection)
  # Implement me first!
  #
  # Consult README for inputs and outputs
  index = 0
  while index < collection.length do
    return collection[index] if name === collection[index][:item]
    index += 1
  end
  nil
end

def consolidate_cart(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This returns a new Array that represents the cart. Don't merely
  # change `cart` (i.e. mutate) it. It's easier to return a new thing.
  index = 0
  result = []

  while index < cart.count do
    item_name = cart[index][:item]
    sought_item = find_item_by_name_in_collection(item_name, result)
    if sought_item
      sought_item[:count] += 1
    else
      cart[index][:count] = 1
      result << cart[index]
    end
    index += 1
  end

  result
end

def coupon_map(c)
  rounded_unit_price = (c[:cost].to_f * 1.0 / c[:num]).round(2)
  {
    :item => "#{c[:item]} W/COUPON",
    :price => rounded_unit_price,
    :count => c[:num]
  }
end

def apply_coupon_to_cart(matching_item, coupon, cart)
  matching_item[:count] -= coupon[:num]
  item_with_coupon = coupon_map(coupon)
  item_with_coupon[:clearance] = matching_item[:clearance]
  cart << item_with_coupon
end

def apply_coupons(cart, coupons)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  index = 0
  while index < coupons.count do
    coupon = coupons[index]
    item_with_coupon = find_item_by_name_in_collection(coupon[:item], cart)
    item_is_in_basket = !!item_with_coupon
    bulk_order = item_is_in_basket && item_with_coupon[:count] >= coupon[:num]

    if item_is_in_basket and bulk_order
      apply_coupon_to_cart(item_with_coupon, coupon, cart)
    end
    index += 1
  end

  cart
end

def apply_clearance(cart)
  # Consult README for inputs and outputs
  #
  # REMEMBER: This method **should** update cart
  index = 0
  while index < cart.length do
    item = cart[index]
    if item[:clearance]
      discounted_price = ((1 - CLEARANCE_DISCOUNT) * item[:price]).round(2)
        item[:price] = discounted_price
    end
    index += 1
  end

  cart
end

def checkout(cart, coupons)
  # Consult README for inputs and outputs
  #
  # This method should call
  # * consolidate_cart
  # * apply_coupons
  # * apply_clearance
  #
  # BEFORE it begins the work of calculating the total (or else you might have
  # some irritated customers
  total = 0
  index = 0

  ccart = consolidate_cart(cart)
  apply_coupons(ccart, coupons)
  apply_clearance(ccart)

  while index < ccart.length do
    total += items_total_cost(ccart[index])
    index += 1
  end

  total >= 100 ? total * (1.0 - VOLUME_DISCOUNT) : total
end

def items_total_cost(index)
  index[:count] * index[:price]
end
