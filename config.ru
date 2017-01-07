require './lib/racker'

use Rack::Static, urls: ['/css'], root: 'public'
use Rack::Session::Cookie, key: 'rack.session',
                           path: '/',
                           secret: '#lkjdf5234%'
Slim::Engine.set_options pretty: true
Slim::Include.set_options include_dirs: ["#{Dir.pwd}/lib/views/partials"]
run Racker.new
