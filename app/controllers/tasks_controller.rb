class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy, :edit, :show, :update]
  
  def index
    @tasks = current_user.tasks.order(id: :desc)
  end
  
  def show
  end
  
  def new
    @task = current_user.tasks.build
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = "正常に作成されました。"
      redirect_to root_url
    else
      @tasks = current_user.tasks.order(id: :desc)
      flash.now[:danger] = "作成されませんでした"
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @task.update(task_params)
      flash[:success] = '正常に更新されました'
      redirect_to "/"
    else
      flash[:danger] = '更新されませんでした'
      redirect_to edit_task_path(params[:id])
    end
  end
  
  def destroy
    @task.destroy
    flash[:success] = '削除されました。'
    redirect_to "/"
  end

  private
  
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
end
