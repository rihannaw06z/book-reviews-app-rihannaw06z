class UsersController < ApplicationController
  # allowing unathenticated users to sign up, but not to access any other actions
  allow_unauthenticated_access only: %i[new create]
  before_action :require_authentication, only: %i[edit update]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
       session = @user.sessions.create!
      cookies.signed[:session_id] = { value: session.id, httponly: true }

      redirect_to root_path, notice: "Welcome! Your account has been created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews
  end

  def update
    if @current_user.update(user_params)
      redirect_to root_path, notice: "Your account has been updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  private
  # Access parameters from the form requesting password for security
  def user_params
    params.require(:user).permit(:username, :email_address, :password, :password_confirmation)
  end
end