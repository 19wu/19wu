json.result 'ok'

json.(@order, :id, :status)

if @order.pending?
  json.link generate_pay_link_by_order(@order)
end
