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
    found = JSON.parse(html_result.body)['found']

    if included
      if found
        @results = "Congratulations! #{word} is a valid English word!"
      else
        @results = "Sorry but #{word} does not seem to be a valid English word."
      end
    else
      @results = "Sorry but #{word} can't be built out of #{letters.join(', ')}"
    end
    # raise
  end
end
