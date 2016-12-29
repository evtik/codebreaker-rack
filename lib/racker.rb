require 'json'
require 'date'
require 'slim'
require 'slim/include'
# require 'slim/logic_less'
require 'codebreaker'

class Racker
  VALID_PATHS = %w(/game /hint /submit_guess /save_results /submit_username)

  class GameSession
    attr_accessor :game, :attempts, :guesses, :game_over,
                  :hint_given, :invalid_input, :error_message,
                  :username_being_added, :stats

    def initialize
      @game = Codebreaker::Game.new
      @guesses = []
      @attempts = 10
    end
  end

  def call(env)
    @request = Rack::Request.new(env)
    @cb_session = @request.session[:cb_session]
    path = @request.path
    return Rack::Response.new(render('index')) if path == '/'
    if VALID_PATHS.include? path then send path[1..-1]
    else Rack::Response.new('Not found', 404)
    end
  end

  def game
    @cb_session = GameSession.new
    @request.session[:cb_session] = @cb_session
    render_game_view
  end

  def hint
    @cb_session.hint_given = true
    render_game_view
  end

  def submit_guess
    guess = @request.params['guess']
    unless @cb_session.attempts.zero?
      if guess =~ /\A[1-6]{4}\z/
        process_valid_guess(guess)
      else
        @cb_session.invalid_input = guess
        @cb_session.error_message = 'Only a 4-digit number is allowed.'
      end
    end
    render_game_view
  end

  def process_valid_guess(guess)
    @cb_session.invalid_input = nil
    @cb_session.attempts -= 1
    if guess == @cb_session.game.code
      @cb_session.guesses << [guess, '++++']
      @cb_session.game_over = true
    else
      feedback = @cb_session.game.submit_guess(guess)
      @cb_session.guesses << [guess, feedback]
      @cb_session.game_over = true if @cb_session.attempts.zero?
    end
  end

  def save_results
    @cb_session.username_being_added = true
    render_game_view
  end

  def submit_username
    username = @request.params['username']
    if username =~ /\A\s*\w+\s*\z/
      process_valid_username(username.strip)
    else
      @cb_session.invalid_input = username
      @cb_session.error_message =
        'Only letters and digits with no spaces are allowed.'
      render_game_view
    end
  end

  def process_valid_username(username)
    read_stats
    @stats[username] = [
      Date.today.to_s,
      @cb_session.game.code,
      @cb_session.hint_given ? 'yes' : 'no',
      @cb_session.guesses.length,
      @cb_session.guesses.last[1] == '++++' ? 'won' : 'lost'
    ]
    @stats.sort_by { |_k, v| v.first }.reverse
    write_stats
    render_stats_view
  end

  def read_stats
    @stats = JSON.parse(File.read('stats.json'))
  rescue
    @stats = {}
  end

  def write_stats
    File.write('stats.json', JSON.pretty_generate(@stats))
  rescue
    puts 'Error writing stats!'
  end

  def render_game_view
    Rack::Response.new(render('game', cb_session: @cb_session))
  end

  def render_stats_view
    Rack::Response.new(render('stats', stats: @stats))
  end

  def render(template, data = {})
    @layout ||= Slim::Template
                .new(File.expand_path('../views/layout.slim', __FILE__))
    path = File.expand_path("../views/#{template}.slim", __FILE__)
    @layout.render { Slim::Template.new(path).render(Object.new, data) }
  end
end
