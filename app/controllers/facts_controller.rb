class FactsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def index
    @facts = if params[:keywords]
      Fact.where('title like ?', "%#{params[:keywords]}%")
    else
      Fact.all
    end
    respond_to do |format|
      format.html
      format.json { render :json => json_attributes(@facts) }
    end
  end

  def show
    @fact = Fact.find(params[:id])
    render :json => json_attributes(@fact)
  end

  def create
    @fact = Fact.new(fact_params)
    if @fact.save
      render :json => json_attributes(@fact)
    else
      render :json => {errors: @fact.errors}, status: :bad_request
    end
  end

  def update
    @fact = Fact.find params[:id]
    if @fact.update(fact_params)
      render :json => json_attributes(@fact)
    else
      render :json => {errors: @fact.errors}, status: :bad_request
    end
  end

  def destroy
    @fact = Fact.find params[:id]
    @fact.destroy
    render :json => {}, status: :ok
  end

  private

  def fact_params
    params.require(:fact).permit(:title, :subject)
  end

  def json_attributes(fact_relation)
    fact_relation.as_json(only: [:id, :title, :subject])
  end
end