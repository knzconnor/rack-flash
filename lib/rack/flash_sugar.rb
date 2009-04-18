module Rack
  module FlashSugar
    def flash
      env['rack.flash']
    end
  end
end