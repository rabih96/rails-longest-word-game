require 'uri'
require 'net/http'

class GamesController < ApplicationController
  def new
    charset = %w[A C D E F G H J K M N P Q R T V W X Y Z]
    @letters = (0...10).map { charset.to_a[rand(charset.size)] }
  end

  def score
    word = params[:word]
    letters = params[:letters].split(' ')

    included = word.upcase.chars.uniq.all? { |x| letters.count(x) >= word.upcase.chars.count(x) }

    uri = URI("https://wagon-dictionary.herokuapp.com/#{word}")
    html_result = Net::HTTP.get_response(uri)
    @found = JSON.parse(html_result.body)['found']
    @score = 0

    if included
      if @found
        @results = "Congratulations! #{word} is a valid English word!"
        @score = 10 * word.length
        if session[:total_score].present?
          session[:total_score] += @score
        else
          session[:total_score] = @score
        end
        @total_score = session[:total_score]
      else
        @results = "Sorry but #{word} does not seem to be a valid English word."
      end
    else
      @results = "Sorry but #{word} can't be built out of #{letters.join(', ')}"
    end
    # raise
  end
end
