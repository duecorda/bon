class UsersController < ApplicationController

  def auth
    if @current_user = User.authenticate(params[:user])
      session[:user_id] = @current_user.id
      redirect_back_or(root_path)
    else
      redirect_to signin_path, notice: '아이디나 비밀번호가 틀렸습니다.'
    end
  end
  
  def signin
  end
  
  def signout
    session[:user_id] = nil
    cookies[:client_crumbs] = nil
    # reset_session
    redirect_back_or
  end

  def index
    @users = User.all.order("id desc")
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_back_or(root_path)
    else
      render :action => :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])

    if @user != @current_user && !@current_user.is_admin?
      raise PermissionException
    end
  end

  def update
    @user = User.find(params[:id])

    if @user != @current_user && !@current_user.is_admin?
      raise PermissionException
    end
    
    # prevent empty password
    if params[:user][:password].blank?
      params[:user].delete(:password)
    end

    if @user.update_attributes(user_params)
      redirect_to edit_user_path, :notice => "수정완료"
    else
      render :action => :edit
    end
  end

  private

    def user_params
      params.require(:user).permit(:login, :password, :password_confirmation)
    end
end
