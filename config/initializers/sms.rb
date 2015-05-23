Settings.sms.each do |service, account|
  options = { password: account['password'] }
  options[:username] = account['username'] if account['username']
  ChinaSMS.use service.to_sym, options
end
