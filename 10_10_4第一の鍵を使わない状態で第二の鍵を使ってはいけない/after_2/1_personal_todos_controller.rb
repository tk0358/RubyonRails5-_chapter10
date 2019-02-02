# モデルで処理すべきことをモデルに移す（モデル整理化後）
# app/controllers/personal_todos_controller.rb

class PersonalTodosController < ApplicationController
  def index
    base_date = params[:base_date]&.to_date || Date.current
    @todos = current_user.todos.due_in_week(base_date, current_user.settings.week_start_day)
    @most_important_todo = @todos.most_important
  end
end
