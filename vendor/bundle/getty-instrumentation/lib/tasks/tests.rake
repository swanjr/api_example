desc "Runs all tests"
task :tests => [ 'cucumber:all' ]
task :t => :tests