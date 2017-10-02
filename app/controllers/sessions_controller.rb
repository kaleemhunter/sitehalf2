class SessionsController < ApplicationController

  def new

  end

  def create
    #byebug
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, You've successfully logged in"
      redirect_to user_path(user)
    else
      flash.now[:danger] = "Something was wrong with your credentials"
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You've successfully logged out"
    redirect_to root_path
  end

end
