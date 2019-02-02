# カスタムヘルパーを小さくした後
# app/helpers/application_helper.rb

module ApplicationHelper
  def button_classes(color = nil)
    color_class = color ? "btn-#{color}" : 'btn-green'
    ['btn', color_class]
  end
end
