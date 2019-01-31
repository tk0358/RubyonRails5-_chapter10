# 10-7-2-1
# case1 多少変わった形のparamsからの代入コードをモデルに寄せる
# 変更前コントローラ app/controllers/users_controller.rb

# Userモデルクラスが、ユーザーの郵便番号をデータとして抱えているとする。
# ここで、データベースでは「111-1111」のような文字列の形で保管しているものの、
# ユーザーに入力してもらう画面では、２つのテキスト入力蘭で入力してもらうことになっているとする。
# このように画面仕様とモデル仕様の間にギャップがある場合の１つのやり方は、
# コントローラでギャップを埋めるというやり方。そのためのコードは次のようになる。

class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    @user.zip_code = params[:zip1].present? && params[:zip2].present? ? [params[:zip1], params[:zip2]].join('-') : nil #  1.コントローラで郵便番号に関するうパラメータを取り出し、モデルで扱いやすい郵便番号の形に組み立てて代入している。
    if @user.save
      redirect_to user_path(@user)
    else
      @zip1 = params[:zip1] # 2. 検証エラーとなった時の再表示をケア
      @zip2 = params[:zip2]
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    @zip1 = @user.zip_code.present? ? @user.zip_code.split('-').first : nil # 3. 編集画面のためにデータベースのデータをフィールド構造に合わせて分割する
    @zip2 = @user.zip_code.present? ? @user.zip_code.split('-').last : nil
  end

  def user_params
    params.require(:user).permit(:name, ...)
  end
end
