class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update]
  # GET /users/1
  def show
    render json: User.find(params[:id])
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created
    else
      render json: @user, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
  # Only allow a trusted parameter "white list" through
  def user_params
    params.require(:user).permit(:email, :password)
  end


  def set_user
    @user = User.find(params[:id])
  end
end