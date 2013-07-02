Settings.sms.each do |service, account|
  ChinaSMS.use service.to_sym, username: account['username'], password: account['password']
end
