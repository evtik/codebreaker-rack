require 'slim'
# require 'slim/logic_less'
require 'codebreaker'

class Racker
  class GameSession
    attr_accessor :game, :guesses,
      :game_over, :hint_given, :invalid_submit, :attempts

    def initialize
      @game = Codebreaker::Game.new
      @guesses = []
      @attempts = 10
    end
  end

  def call(env)
    @request = Rack::Request.new(env)
    case @request.path
    when '/' then Rack::Response.new(render('index.slim'))
    when '/game' then new_game
    when '/hint' then hint
    when '/submit_guess' then submit_guess
    else Rack::Response.new('Not found', 404)
    end
  end

  def new_game
    cb_session = GameSession.new
    @request.session[:cb_session] = cb_session
    render_game_view(cb_session)
  end

  def hint
    cb_session = @request.session[:cb_session]
    cb_session.game.hint
    cb_session.hint_given = true
    render_game_view(cb_session)
  end

  def submit_guess
    guess = @request.params['guess']
    cb_session = @request.session[:cb_session]
    if guess =~ /\A[1-6]{4}\z/
      process_valid_guess(cb_session, guess)
    else
      cb_session.invalid_submit = guess
    end
    render_game_view(cb_session)
  end

  def process_valid_guess(cb_session, guess)
    cb_session.invalid_submit = nil
    cb_session.attempts -= 1
    if guess == cb_session.game.code
      cb_session.guesses << [guess, '++++']
      cb_session.game_over = true
    else
      feedback = cb_session.game.submit_guess(guess)
      cb_session.guesses << [guess, feedback]
      cb_session.game_over = true if cb_session.attempts.zero?
    end
  end

  def render_game_view(cb_session)
    Rack::Response.new(render('game.slim', cb_session: cb_session))
  end

  def render(template, data = {})
    @layout ||= Slim::Template
                .new(File.expand_path('../views/layout.slim', __FILE__))
    path = File.expand_path("../views/#{template}", __FILE__)
    @layout.render { Slim::Template.new(path).render(Object.new, data) }
  end
end
