require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      letter = ('A'..'Z').to_a.sample
      @letters << letter
    end
  end

  def score
    # params[:word] is word
    letters = params[:letters].chars
    grid = in_grid?(params[:word], letters) # true or false
    input = valid_english?(params[:word]) # array
    found = valid_english?(params[:word])[0]# true or false
    length = input[1] # number
    error_message = input[2] # error
    @message = options(params[:word], found, grid, letters)

  end

  def in_grid?(word, letters)
    correct = true
    word.split("").each do |letter|
      if letters.include?(letter)
        index = letters.index(letter)
        letters[index] = ''
      else
        correct = false
      end
    end
    return correct
  end

  def valid_english?(input)
    url = "https://wagon-dictionary.herokuapp.com/#{input}"
    word = JSON.parse(URI.open(url).read)
    found = word['found']
    length = word['length'] if found
    error_message = word['error'] unless found
    [found, length, error_message]
  end

  def options(word, found, grid, letters)
    if grid && found
      "Congratulations! #{word} is a correct word to "
    elsif grid && !found
      "Sorry! #{word} does not seem to be a valid word"
    else
      "Sorry, but #{word} cannot be build out of #{letters} "
    end
  end
end
