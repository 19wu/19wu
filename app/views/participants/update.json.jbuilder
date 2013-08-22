json.result 'ok'

json.(@participant, :id, :checkin_code)

json.quantity @participant.order.quantity
