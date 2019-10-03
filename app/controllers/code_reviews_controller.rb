# frozen_string_literal: true

class CodeReviewsController < ApplicationController
  def index
    render json: { text: 'Hello world!' }
  end

  def create
    render json: { text: 'Hello world!' }
  end
end
