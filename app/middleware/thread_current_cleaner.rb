# Thread.current variables can persist between requests. This middleware can be used
# to clear the variables in the Thread.current root fiber. All variable names specified
# in the variable_names configuration array will be set to nil.
#class ThreadCurrentCleaner
  #cattr_accessor :variable_names

  #def self.configure
    #yield(self)
  #end

  #def initialize(app)
    #@app = app
  #end

  #def call(env)
    #@app.call(env)
  #ensure
    #self.variable_names.each do |key|
      #Thread.current[key] = nil
    #end
  #end
#end
