module Rack  
  class Flash    

    def initialize(app, opts={})
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
      return unless target
      target = [target] unless target.is_a?(Array)
      target.each { |klass| klass.send :include, FlashSugar }
    end
  end
end
