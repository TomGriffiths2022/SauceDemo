# Parallel tests CLI options: https://github.com/grosser/parallel_tests/blob/master/lib/parallel_tests/cli.rb#L182

FORMATTER = 'pretty'
PARALLEL = ParallelTests::CLI.new

namespace :functional_tests do
  require 'parallel_tests'

  # @usage: bundle exec rake "functional_tests:run[2, features, @positive]"
  desc 'Run the functional tests in parallel'
  task :run, %i[processes feature_path tag] do |_t, args|
    args.with_defaults(processes: '1', feature_path: 'features', tag: nil)

    tags = args.tag.nil? ? 'not @exclude' : "#{args.tag} and not @exclude"

    LOG.info { "Processes: '#{args.processes}' | Feature path: '#{args.feature_path}' | Tags: '#{tags}' | Formatter: '#{FORMATTER}'" }

    cmd = %W[ -n #{args.processes} --type cucumber --group-by scenarios --serialize-stdout
              -- -f #{FORMATTER} --out /dev/null -f progress -t #{tags}
              -- #{args.feature_path} ]

    PARALLEL.run(cmd)
  end

  # @usage: bundle exec rake "functional_tests:blitz[2, @positive]"
  desc 'Run the same tests multiple times'
  task :blitz, %i[repititions tags] do |_t, args|
    args.with_defaults(repititions: 1, tags: nil)

    tags = args.tags.nil? ? 'not @exclude' : "#{args.tags} and not @exclude"

    LOG.info { "Running blitz: #{args[:repititions]} times using tags: #{tags}" }

    args[:repititions].to_i.times { sh "bundle exec cucumber -t '#{tags}'" }
  end
end
