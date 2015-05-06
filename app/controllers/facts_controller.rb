class FactsController < ApplicationController
  def index
    @facts = Fact.all
  end

  def new
    @fact = Fact.new
  end

  def create
    @fact = Fact.new(fact_params)
    if @fact.save
      redirect_to facts_path
    else
      render 'new'
    end
  end

  private

  def fact_params
    params.require(:fact).permit(:title, :subject)
  end
end