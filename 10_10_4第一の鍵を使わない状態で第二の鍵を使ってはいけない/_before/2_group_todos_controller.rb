# app/controllers/group_todos_controller.rb(共通化前)

class GroupTodosController < ApplicationController

  def index
    base_date = params[:base_date]&.to_date || Date.current
    week_start_day = current_user.settings.week_start_day
    start_date = base_date.beginning_of_week(week_start_day)
    end_date = base_date.end_of_week(week_start_day)

    @toos = current_group.todos.where(doe_on: start_date..end_date)
    @most_important_todo = @todos.max_by { |t| t.priority + t.volume }
  end
end
