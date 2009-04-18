module Rack  
  module BuilderInsSugar
    def self.included(klass)
      klass.send :alias_method, :use_without_back_reference, :use
      klass.send :alias_method, :use, :use_with_back_reference
      
      klass.send :alias_method, :run_without_back_reference, :run
      klass.send :alias_method, :run, :run_with_back_reference
    end

    attr_accessor :ins
    def use_with_back_reference(middleware, *args, &block)
      middleware.extend BuilderBackReference
      middleware.rack_builder = self
      use_without_back_reference(middleware, *args, &block)
    end

    def run_with_back_reference(app)
      app.class.extend BuilderBackReference
      app.class.rack_builder = self
      run_without_back_reference(app)
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