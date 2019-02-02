# モデルで処理した方がよいコードを抱えたまま、コントローラ共通化
# app/controllers/personal_todos_controller

class PersonalTodosController < ApplicationController
  include TodoFinding

  def index
    set_todos_in_week
  end

  private

  def todo_holder
    current_user
  end
end
