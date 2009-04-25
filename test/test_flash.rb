require File.dirname(__FILE__) + '/helper'

describe 'Rack::Flash' do
  
  describe 'integration' do
    it 'provides :sweep option to clear unused entries' do
      mock_app {
        use Rack::Flash, :sweep => true

        set :sessions, true

        get '/' do
          'ok'
        end
      }

      fake_flash = Rack::FakeFlash.new(:foo => 'bar')

      get '/', :env => { 'rack.flash' => fake_flash }

      fake_flash.should.be.flagged
      fake_flash.should.be.swept
      fake_flash.store[:foo].should.be.nil
    end
  end

  # Testing sessions is a royal pain in the ass.
end