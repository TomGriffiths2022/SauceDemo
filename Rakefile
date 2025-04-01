# Tool to define tasks to be run in the command line
# Tasks are loaded in from rakelib by default, use `rake -T -A` to see all tasks

require 'config'
require 'dvla/herodotus'
require 'open3'
require 'parallel_tests'

Config.load_and_set_settings(Config.setting_files('./config', ENV.fetch('ENVIRONMENT', 'local')))

LOG = DVLA::Herodotus.logger('rake')
LOG.level = Logger.const_get(Settings.test.log_level)
