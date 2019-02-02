#　モデルで処理した方がよいコードを抱えたまま、コントローラ共通化
# app/controllers/group_todos_controller.rb

class GroupTodosController < ApplicationController
  include TodoFinding

  def index
    set_todos_in_week
  end

  private

  def todo_holder
    current_group
  end
end
