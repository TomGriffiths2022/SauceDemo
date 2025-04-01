# Lint cucumber step definitions

namespace :lint do
  # @usage: bundle exec rake "lint:unused_step_defs"
  # -B num: Grabs the 'num' lines before match
  # -v: remove matches
  desc 'Scan for unused step definitions'
  task :unused_step_defs do
    LOG.info { 'Starting scan for unused step definitions...'.cyan }

    cmd = "bundle exec cucumber --dry-run --format stepdefs | grep -B1 'NOT MATCHED BY ANY STEPS' | grep -v 'NOT MATCHED BY ANY STEPS' | grep -v 'be axe clean'"
    stdout, _stderr, _status = Open3.capture3(cmd)
    raise StandardError, "Fix the following unused step definitions: \n#{stdout.red}\n" unless stdout.empty?

    LOG.info { 'No unused step definitions found'.green }
  end

  # @usage: bundle exec rake "lint:undefined_step_defs"
  # -A num: Grabs the 'num' lines after match
  desc 'Scan for undefined step definitions'
  task :undefined_step_defs do
    LOG.info { 'Starting scan for undefined step definitions...'.cyan }

    cmd = "bundle exec cucumber --dry-run --format stepdefs | grep -A100 'You can implement step definitions for undefined steps with these snippets:'"
    stdout, _stderr, _status = Open3.capture3(cmd)
    raise StandardError, "Fix the following undefined step definitions: \n#{stdout.red}\n" unless stdout.empty?

    LOG.info { 'No undefined step definitions found'.green }
  end
end
