class FactsController < ApplicationController
  def index
  end

  def new
  end

  def create
    render plain: params[:fact].inspect
  end
end