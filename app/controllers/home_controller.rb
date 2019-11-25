# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    offset = rand(Quote.count)
    @quote = Quote.offset(offset).first
  end
end
