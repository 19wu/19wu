CarrierWave.configure do |config|
  config.asset_host = "http://#{Settings.host}"
  if Rails.env.test? # http://git.io/XhkwBw
    config.storage = :file
    config.enable_processing = false
  end
end
