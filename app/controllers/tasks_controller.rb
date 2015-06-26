class TasksController < ApplicationController

  #PUT /tasks/seen
  def seen
    Task.find(params[:id]).update(seen: true)

    redirect_to Policy_path(params[:policy])
  end
end
