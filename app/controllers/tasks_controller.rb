class TasksController < ApplicationController
 before_filter :get_list

  def index
    @tasks = @list.tasks.all

    respond_to do |format|
      format.html
      format.json { render json: @tasks }
    end
  end

  def show
    @task = @list.tasks.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @task }
    end
  end

  def new
    @task = @list.tasks.build

    respond_to do |format|
      format.html
      format.json { render json: @task }
    end
  end

  def edit
    @task = @list.tasks.find(params[:id])
  end

  def create
    @task = @list.tasks.build(params[:task])

    respond_to do |format|
      if @task.save
        format.html { redirect_to @list, notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: [@list, @task] }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @task = @list.tasks.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to @list, notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task = @list.tasks.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to @list }
      format.json { head :no_content }
    end
  end

  private
    def get_list
      @list = List.find(params[:list_id])
    end


end
