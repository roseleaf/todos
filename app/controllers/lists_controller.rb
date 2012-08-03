class ListsController < ApplicationController

  def index
    @lists = List.all
    respond_to do |format|
      format.html 
      format.json { render json: @lists }
    end
  end

  def show
    @list = List.find(params[:id])
    @task = @list.tasks.build

    respond_to do |format|
      format.html 
      format.json { render json: @list }
    end
  end

  def new
    @list = List.new

    respond_to do |format|
      format.html
      format.json { render json: @list }
    end
  end

  def edit
    @list = List.find(params[:id])
  end

  def create
    @list = List.new(params[:list])

    respond_to do |format|
      if @list.save
        format.html { redirect_to @list, notice: 'List was successfully created.' }
        format.json { render json: @list, status: :created, location: @list }
      else
        format.html { render action: "new" }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @list = List.find(params[:id])

    respond_to do |format|
      if @list.update_attributes(params[:list])
        format.html { redirect_to @list, notice: 'List was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @list = List.find(params[:id])
    @list.destroy

    respond_to do |format|
      format.html { redirect_to lists_url }
      format.json { head :no_content }
    end
  end
end
