class FactsController < ApplicationController
  def index
    @facts = Fact.all
  end

  def new
  end

  def create
    @fact = Fact.new(fact_params)
    @fact.save
    redirect_to facts_path
  end

  private

  def fact_params
    params.require(:fact).permit(:title, :subject)
  end
end