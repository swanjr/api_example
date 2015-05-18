module Helpers
  class RenderFields
    include Uber::Callable

    def initialize(field)
      @field = field.to_sym
    end

    def call(represented, *args)
      #fields = args[:fields]
      puts args.inspect
    end
  end
end
