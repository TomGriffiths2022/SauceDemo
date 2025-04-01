# Load configuration for Config gem
Config.load_and_set_settings(Config.setting_files('./config', ENV.fetch('ENVIRONMENT', 'local')))
