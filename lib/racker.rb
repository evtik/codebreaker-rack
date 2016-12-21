require 'slim'

class Racker
  def call(env)
    Rack::Response.new(render('index.slim'))
  end

  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    Slim::Template.new(path).render
  end
end