
APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..", ".."))
$: << File.join(APP_ROOT, "lib")

require 'cucumber/rspec/doubles'
require 'rspec-spies'

require 'getty/instrumentation'

