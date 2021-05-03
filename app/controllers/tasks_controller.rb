class TasksController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :create, :edit, :update]
  before_action :correct_user, only: [:destroy]
  
  def index
    if logged_in?
      @task = current_user.tasks.build  # form_with 用
      @tasks = current_user.tasks.order(id: :desc)
    end
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = "正常に作成されました"
      redirect_to root_url
    else
      @tasks = current_user.tasks.order(id: :desc)
      flash.now[:danger] = "作成されませんでした"
      render "tasks/index"
    end
  end
  
  def edit
      @task = current_user.tasks.find_by(id: params[:id])
      if @task==nil
        redirect_to "/"
      end
  end
  
  def update
    @task = current_user.tasks.find(params[:id])
    if @task.update(task_params)
      flash[:success] = '正常に更新されました'
      redirect_to "/"
    else
      @tasks = current_user
      flash.now[:danger] = '更新されませんでした'
      render :edit
    end
  end
  
  def destroy
    @task.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_back(fallback_location: root_path)
  end

  private

  # Strong Parameter
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
