# update_button_tagというヘルパーは、更新ボタンを共通化するために作られたものだが、
# 典型的な「何でも屋」状態に陥っている
# app/helpers/application_helper.rb

module ApplicationHelper
  def update_button_tag(content, color: nil, record: nil, force_enable: false)
    disabled =
      if force_enable
        false
      else
        case record
        when Comment
          record.locked?
        when Post
          !record.created_at.today?
        else
          false
        end
      end

    class_name = color ? "btn-#{color}" : 'btn-green'

    button_tag(content, disabled: disabled, class: ['btn', class_name])
  end
end

=begin
update_button_tagでは次のような仕事を行っている
1.ボタンを無効(disabled)にするかどうかの制御
2.btnというCSSクラスの付与
3.btn-greenなど、ボタンの色を与えるためのCSSクラスの付与
4.更新ボタンをタグとして出力

もともとのヘルパーの目的は２と３。
しかし、いろいろな画面から利用されるうちに、１についての処理が追加され、条件分岐が増えていった
このヘルパーが散らかった原因は、４の仕事が本質的に大きすぎることにある。
ボタンについては、２や３だけでなく、１の制御も必要なことが後になって判明したわけだが、
枠組みとしてボタン表示処理として共通化されていたために、他の機能がそれに乗るためには、
ボタン表示処理そのものの拡張が必要になった。
そうして、１の更新ボタンを無効にする制御についての各機能の要件の差異が、
このヘルパーの内部に複雑な条件として混ざり込んでしまった。

この例では、１と４の仕事をヘルパーで行うのを辞めて、２と３の仕事だけを行う小さなヘルパー「button_classes」を作って利用すれば、スッキリする

また、条件分岐のところで、特定のモデルに関する処理が入り込んでしまっている。
=end
