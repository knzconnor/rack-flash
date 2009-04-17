module Rack
  class Builder
    attr :ins
    def use(middleware, *args, &block)
      middleware.instance_variable_set "@rack_builder", self
      def middleware.rack_builder
        @rack_builder
      end
      @ins << lambda { |app| 
        middleware.new(app, *args, &block) 
      }
    end

    def run(app)
      klass = app.class
      klass.instance_variable_set "@rack_builder", self
      def klass.rack_builder
        @rack_builder
      end
      @ins << app #lambda { |nothing| app }
    end
    
    def leaf_app
      ins.last
    end
  end
end