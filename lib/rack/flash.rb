module Rack  
  class Flash

    # -------------------------------------------------------------------------
    # - Rack Middleware implementation

    def initialize(app, opts={})
      if klass = app_class(opts[:sugar_target])
        klass.send :include, FlashSugar
      end

      @app, @opts = app, opts
    end

    def call(env)
      env['rack.flash'] ||= Rack::Flash::FlashHash.new(env['rack.session'], @opts)

      if @opts[:sweep]
        env['rack.flash'].flag!
      end

      res = @app.call(env)

      if @opts[:sweep]
        env['rack.flash'].sweep!
      end

      res
    end

    private

    def app_class(target)
      case klass = target
      when Class
        klass
      #when :auto
      #  self.class.rack_builder.leaf_app.class
      #when nil, false, :none aka else
      #  nil
      end
    end
  end
end
