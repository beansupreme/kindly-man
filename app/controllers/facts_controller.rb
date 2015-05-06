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

  def edit
    @fact = Fact.find params[:id]
  end

  def update
    @fact = Fact.find params[:id]
    if @fact.update(fact_params)
      redirect_to facts_path
    else
      render 'edit'
    end
  end

  private

  def fact_params
    params.require(:fact).permit(:title, :subject)
  end
end