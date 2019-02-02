# app/controllers/personal_todos_controller.rb(共通化前)

class PersonalTodosController < ApplicationController

  def index
    base_date = params[:base_date]&.to_date || Date.current
    week_start_day = current_user.settings.week_start_day
    start_date = base_date.beginning_of_week(week_start_day)
    end_date = base_date.end_of_week(week_start_day)

    @toos = current_user.todos.where(doe_on: start_date..end_date)
    @most_important_todo = @todos.max_by { |t| t.priority + t.volume }
  end
end

=begin
TODO管理のアプリケーション。２つのコントローラがある
1.ユーザー個人のTODOリストを管理するためのPersonalTodosController
2.ユーザーの所属するグループのTODOリストを管理するためのGroupTodosController
この２つのコントローラは非常によく似たindexアクションを持っており、
一週間分のTODOデータを表示するための準備を行う。

１行・１箇所の違いしかないので共通化できそう。

共通化の方式として
A.継承を利用。アクション内の共通処理を抽出して、ApplicationControllerや新規に追加する基底クラスに持たせる
B.モジュールを利用
  a.アクション内の共通処理を抽出して、モジュールにもたせ、includeする
  b.indexアクションそのものをモジュールに持たせ、includeする

ここではB-aのやりかたで共通化を試みる
TodoFindingモジュールを新たに作成し、indexアクション内の処理をset_todos_in_weekというprivateメソッドに切り出す。
その差異、唯一異なる、検索の起点（current_userなのか、current_groupなのか）については、
それぞれのコントローラにこの起点を返すtodo_holderメソッドを作り、それを共通コードから呼び出すことにする（→after_1へ）
=end
