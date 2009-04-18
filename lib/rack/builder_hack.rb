module Rack
  class Builder
    include Rack::BuilderLeafSugar
  end
  
  module BuilderBackReference
    def rack_builder
      @rack_builder
    end
    def rack_builder=(value)
      @rack_builder = value
    end
  end
  
  module BuilderLeafSugar
    def self.included(klass)
      klass.send :alias_method, :use_without_leaf_sugar, :use
      klass.send :alias_method, :use, :use_with_leaf_sugar
      
      klass.send :alias_method, :run_without_leaf_sugar, :run
      klass.send :alias_method, :run, :run_with_leaf_sugar
    end

    attr_accessor :ins
    def use_with_leaf_sugar(middleware, *args, &block)
      middleware.extend BuilderBackReference
      middleware.rack_builder = self
      use_without_leaf_sugar(middleware, *args, &block)
    end

    def run_with_leaf_sugar(app)
      app.class.extend BuilderBackReference
      app.class.rack_builder = self
      run_without_leaf_sugar(app)
    end
    
    def leaf_app
      ins.last
    end
  end
end