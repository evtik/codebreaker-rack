require './lib/racker'
use Rack::Static, urls: ['/css'], root: 'public'
use Rack::Session::Cookie, key: 'rack.session',
                           path: '/',
                           secret: '#lkjdf5234%'
Slim::Engine.set_options pretty: true
run Racker.new
