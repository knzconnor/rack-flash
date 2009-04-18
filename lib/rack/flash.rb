module Rack  
  class Flash
    # Raised when the session passed to FlashHash initialize is nil. This
    # is usually an indicator that session middleware is not in use.
    class SessionUnavailable < StandardError; end
    
    # -------------------------------------------------------------------------
    # - Rack Middleware implementation

    def initialize(app, opts={})
      #unless self.class.rack_builder.ins.any? {|tuple| tuple.is_a?(Array) && tuple.first WHAT OPERATOR GOES HERE Rack::Session }
      #  raise Rack::Flash::SessionUnavailable.new('Rack::Flash depends on session middleware.')
      #end
      
      add_sugar(opts[:sugar_target])

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

    def add_sugar(target)
      case target
      when Array
        target.each { |klass| klass.send :include, FlashSugar }
      when Class
        target.send :include, FlashSugar
      #when :auto
      #  self.class.rack_builder.inner_app.class.send :include, FlashSugar
      #else #when nil, false, :none, etc
      end
    end
  end
end
