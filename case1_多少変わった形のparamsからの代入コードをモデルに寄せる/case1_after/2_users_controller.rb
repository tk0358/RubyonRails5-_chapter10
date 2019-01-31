# 10-7-2-1
# case1 多少変わった形のparamsからの代入コードをモデルに寄せる
# 変更後コントローラ　app/models/user.rb

class UsersController < ApplicationController
  def create
    @user = User.new(user_params) # 5. params[:user][:zip1]といった形のパラメータを一括代入で受け取る
    if @user.save
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:zip1, :zip2, :name, ...)
  end
end

# おかげで、コントローラを標準的なRailsのCRUDのコードの状態までスリム化することができた。
# 本例のようなやり方は、モデルの属性への代入方法を１種類に統一できるような場合には大変便利
