if Rails.env.test? # http://git.io/XhkwBw
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end
