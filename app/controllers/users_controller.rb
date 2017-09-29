class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show, :destroy]
  before_action :require_user, except: [:new, :create, :index, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params_user)

    if @user.save
      flash[:success] = "Welcome to my blog #{@user.username}"
      session[:user_id] = @user.id
	    redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(params_user)
      flash[:success] = "Your account was successfully updated"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def destroy
    @user = User.find(params[:id])
    if @current_user == @user
      @user.destroy
      flash[:danger] = "You have successfully deleted your account and logged out"
      session[:user_id] = nil
      redirect_to root_path
    else
      @user.destroy
      flash[:danger] = "Account was successfully deleted"
      redirect_to users_path
    end
  end

  private

  def params_user
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user && !current_user.admin?
      flash[:danger] = "You can only edit or delete your account"
      redirect_to root_path
    end
  end

  def require_admin
    if logged_in? && (current_user != @user && !current_user.admin?)
      flash[:danger] = "Only admin can perform this action"
      redirect_to root_path
    end
  end

end
