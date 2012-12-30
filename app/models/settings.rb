# Static settings loaded from the YAML file
class Settings < Settingslogic
  source Rails.root.join('config/settings.yml')
  namespace Rails.env
end
