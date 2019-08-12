require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @test = params[:word].upcase
    @letters = params[:letters]
    @result = grid_test?(@test, @letters) & english_word?(@test)
    # result il se rapport au success dans view score
    if !grid_test?(@test, @letters)
      @message = "Sorry but #{@test} can't be built out of #{@letters}"
    elsif !english_word?(@test)
      @message = "Sorry but #{@test} does not seem to be a valid English word"
    else
      @message = "Congratulations! #{@test} is a valid English word!"
    end
  end

  private

  def grid_test?(word, grid)
    word_array = word.upcase.split('')
    grid = grid.split('')
    result = true
    word_array.each do |letter|
      result = false unless grid.include?(letter)
    end
    result
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
