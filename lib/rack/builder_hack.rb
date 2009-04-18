module Rack  
  module BuilderInsSugar
    def self.included(klass)
      klass.send :remove_method, :use
      klass.send :remove_method, :to_app
            
      klass.send :alias_method, :run_without_back_reference, :run
      klass.send :alias_method, :run, :run_with_back_reference
    end

    attr_accessor :ins
    def use(middleware, *args, &block)
      middleware.extend BuilderBackReference
      middleware.rack_builder = self
      @ins << [middleware, args, block]
    end

    def run_with_back_reference(app)
      app.class.extend BuilderBackReference
      app.class.rack_builder = self
      run_without_back_reference(app)
    end
    
    def to_app
      @ins[-1] = Rack::URLMap.new(inner_app)  if Hash === inner_app
      @ins[0...-1].reverse.inject(inner_app) { |a, e| e[0].new(a, *e[1], &e[2]); }
    end
    
    def inner_app
      ins.last
    end
  end
  
  module BuilderBackReference
    def rack_builder
      @rack_builder
    end
    def rack_builder=(value)
      @rack_builder = value
    end
  end
  
  class Builder
    include Rack::BuilderInsSugar
  end
end