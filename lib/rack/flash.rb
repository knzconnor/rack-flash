module Rack  
  class Flash
    # Raised when the session passed to FlashHash initialize is nil. This
    # is usually an indicator that session middleware is not in use.
    class SessionUnavailable < StandardError; end
    
    # -------------------------------------------------------------------------
    # - Rack Middleware implementation

    def initialize(app, opts={})
      #unless self.class.rack_builder.ins.any? {|tuple| tuple.is_a?(Array) && tuple.first == Rack::Session }
      #  raise Rack::Flash::SessionUnavailable.new('Rack::Flash depends on session middleware.')
      #end
      
      if klass = app_class(opts[:sugar_target])
        klass.send :include, FlashSugar
      end

      @app, @opts = app, opts
    end

    def call(env)
      puts "I'm called and I'll call back down the chain to #{@app}"
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
      when :auto
        self.class.rack_builder.inner_app.class
      #else #when nil, false, :none, etc
      #  nil
      end
    end
  end
end
