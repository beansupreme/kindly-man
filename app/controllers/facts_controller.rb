class FactsController < ApplicationController
  def index
    @facts = Fact.all
    respond_to do |format|
      format.html
      format.json { render :json => json_attributes(@facts) }
    end
  end

  def new
    @fact = Fact.new
  end

  def create
    @fact = Fact.new(fact_params)
    if @fact.save
      respond_to do |format|
        format.html { redirect_to facts_path }
        format.json { render :json => json_attributes(@fact) }
      end
    else
      respond_to do |format|
        format.html { render 'new' }
        format.json { render :json => {errors: @fact.errors}, status: :bad_request }
      end
    end
  end

  def edit
    @fact = Fact.find params[:id]
  end

  def update
    @fact = Fact.find params[:id]
    if @fact.update(fact_params)
      respond_to do |format|
        format.html { redirect_to facts_path }
        format.json { render :json => json_attributes(@fact) }
      end
    else
      respond_to do |format|
        format.html { render 'edit' }
        format.json { render :json => {errors: @fact.errors}, status: :bad_request }
      end
    end
  end

  def destroy
    @fact = Fact.find params[:id]
    @fact.destroy
    respond_to do |format|
      format.html { redirect_to facts_path }
      format.json { render :json => {}, status: :ok }
    end
  end

  private

  def fact_params
    params.require(:fact).permit(:title, :subject)
  end

  def json_attributes(fact_relation)
    fact_relation.as_json(only: [:id, :title, :subject])
  end
end