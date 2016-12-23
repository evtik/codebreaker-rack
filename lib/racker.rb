require 'slim'
require 'codebreaker'

class Racker
  def call(env)
    @request = Rack::Request.new(env)
    case @request.path
    when '/' then index_page
    when '/game' then new_game
    else Rack::Response.new('Not found', 404)
    end
  end

  def index_page
    xyz = 'zyx'
    Rack::Response.new(render('index.slim', aaa: xyz))
  end

  def new_game
    @game = Codebreaker::Game.new
    @digits = '12345'
    Rack::Response.new(render('game.slim', game: @game, digits: @digits))
  end

  def render(template, data = {})
    @layout ||= Slim::Template
                .new(File.expand_path('../views/layout.slim', __FILE__))
    path = File.expand_path("../views/#{template}", __FILE__)
    @layout.render { Slim::Template.new(path).render(Object.new, data) }
  end
end
