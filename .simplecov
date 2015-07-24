if ENV["COV"] == 'true'
  SimpleCov.start 'rails' do
    #Additional configuration beyond the default rails adapter
    add_filter 'lib/tasks'
    add_filter 'spec'
    add_filter 'vendor'
  end

  SimpleCov.minimum_coverage 85
end
