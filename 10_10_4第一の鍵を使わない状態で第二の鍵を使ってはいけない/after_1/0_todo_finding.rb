#　モデルで処理した方がよいコードを抱えたまま、コントローラ共通化
# app/controllers/concerns/todo_finding.rb

# コードの共通点・相違点に着目して、機械的に共通化を図ると、この様になる。
module TodoFinding
  private

  def set_todos_in_week
    base_date = params[:base_date]&.to_date || Date.current
    week_start_day = current_user.settings.week_start_day
    start_date = base_date.beginning_of_week(week_start_day)
    end_date = base_date.end_of_week(week_start_day)

    @toos = todo_holder.todos.where(doe_on: start_date..end_date)
    @most_important_todo = @todos.max_by { |t| t.priority + t.volume }
  end

  def todo_holder
    raise NotImplementedError
  end
end

=begin
一見、妥当な共通化に見えるが、この共通化には問題がある。
それは、そもそもコントローラではなくモデルで処理したほうがよいコードを抱えたまま、
コントローラのレベルで共通化をしてしまっているから

set_todos_in_weekメソッドで行っている処理に注目。
ここでやりたいことは、要するに設定に従って、
ある一週間のタスクを取り出すとともに、
その仲で最重要タスクを見つけ出すこと。
Railsアプリケーションにおいて、「モデルのレコードを取り出す、見つけ出す」ということを管轄するのはモデル。
ここでの処理は本来Todoモデルが行うべき仕事
この処理をモデルへ移す(→after_2へ)

=end
