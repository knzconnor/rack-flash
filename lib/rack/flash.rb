module Rack
  class Flash
    # Raised when the session passed to FlashHash initialize is nil. This
    # is usually an indicator that session middleware is not in use.
    class SessionUnavailable < StandardError; end

    # -------------------------------------------------------------------------
    # - Rack Middleware implementation

    def initialize(app, opts={})
      if klass = app_class(app, opts)
        klass.class_eval do
          def flash; env['rack.flash'] end
        end
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

    def app_class(app, opts)
      return nil if opts.has_key?(:helper) and not opts[:helper]
      opts[:flash_app_class] ||
        defined?(Sinatra::Base) && Sinatra::Base ||
        self.class.rack_builder.leaf_app.class
    end
  end
end
