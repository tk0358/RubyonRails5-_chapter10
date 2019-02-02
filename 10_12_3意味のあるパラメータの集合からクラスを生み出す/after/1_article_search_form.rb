class ArticleSearchForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :user
  attribute :keyword, :string
  attribute :draft, :boolean, default: false

  def search
    scope = Article.all
    scope = scope.matches(keyword) if keyword.present?
    if draft?
      scope = scope.with_draft(user)
    else
      scope = scope.published
    end
    scope
  end
end

=begin
Rails5.2から利用できるようになったActiveModel::Attributesを利用して、draftの値をBooleanにキャストして利用している。

このようなArticleSearchFormを利用する際は、フォーム画面でform_withヘルパーなどを利用して
params[:keyword]ではなくparams[:search][:keyword]、
params[:draft]ではなくparams[:search][:draft]というように、
１つのキーの下にまとめられるような形で情報が送られるようにする。
そうすることで、コントローラで(→articles_controller.rb)で一括代入を行うことが出来る。
=end
