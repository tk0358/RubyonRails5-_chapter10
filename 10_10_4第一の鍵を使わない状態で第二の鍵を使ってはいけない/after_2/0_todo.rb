# モデルで処理すべきことをモデルに移す（モデル整理化後）
# app/models/todo.#!/usr/bin/env ruby -wKU

# Todoモデルにdue_in_weekという検索スコープと、
# most_importantという最重要タスクを発見するためのクラスメソッドを追加している。
# most_importantはスコープからメソッドチェーンでも使えるように作られている。

class Todo < ApplicationRecord
  belongs_to :todoable, polymorphic: true

  scope :due_in_week, -> (base_date, week_start_day) {
    start_date = base_date.beginning_of_week(week_start_day)
    end_date = base_date.end_of_week(week_start_day)
    where(due_on: start_date..end_date)
  }

  def self.most_important
    all.max_by { |t| t.priority + t.volume }
  end
end

=begin
さきほどの、TodoFindingモジュールを作っての共通化のコードと見比べてみると、
コードの量は同じようなものだが、
こちらの方が、無駄に構造を複雑にせず、見通しのよい設計になっている

モデルにコードを記述したことの効果を示す一例として、
たとえば別の機能で、「一週間のタスク中、もっとも期限が迫ったタスクをとりたい」
という別のニーズが生じるケースについて考える。

TodoFindingモジュールのやり方では、コントローラ内でどんなデータをどんなインスタンス変数に格納するかが共通化の主題になっているため、
この新しいニーズを満たすことは出来ず、ただコードを増やすしか手がない。

しかし、モデルを整理した今回のやり方であれば、
most_importantに似たクラスメソッドmost_urgentといったメソッドを定義して、
due_in_week.most_urgentで「もっとも期限が迫ったタスク」を取得することが出来る。
すなわち、一週間のタスクを検索するという絞り込みの部分を簡単に再利用出来る。
=end
