require_relative 'config'

# Configure and initialise Logger output
config = DVLA::Herodotus.config do |configuration|
  configuration.display_pid = true
end

LOG = DVLA::Herodotus.logger('sauce-demo', config:)
LOG.level = Logger.const_get(Settings.test.log_level)
