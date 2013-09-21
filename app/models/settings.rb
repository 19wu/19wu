# Static settings loaded from the YAML file
class Settings < Settingslogic
  source Rails.root.join('config/settings.yml')
  namespace Rails.env

  # '19wu <support@19wu.com>' => 'support@19wu.com'
  def self.raw_email(email)
    email.gsub(/(.*<|>)/, '')
  end
end
