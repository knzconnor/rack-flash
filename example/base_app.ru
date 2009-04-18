require 'rack/request'
require 'rack/response'
require 'rack/showexceptions'
require 'rack/session/cookie'
require File.dirname(__FILE__) + '/../lib/rack-flash'

class Base
  attr_accessor :env
  
  def call(env)
    @env = env
    flash['err'] = "IT'S ALIVE"
    res = Rack::Response.new
    res.write "<title>Flashy</title>"
    res.write "#{flash['err']}"
    res.finish
  end
end
use Rack::Session::Cookie
use Rack::Flash, :sugar_target => Base
use Rack::ShowExceptions
run Base.new