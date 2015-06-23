class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  class PermissionException < Exception; end
  rescue_from PermissionException, :with => :content_403

  rescue_from ActiveRecord::RecordNotFound, :with => :content_404

	def content_403
    flash[:notice] = "권한이 없습니다."
    redirect_back_or(root_path)
	end

	def content_404
    flash[:notice] = "데이터를 찾을 수 없습니다"
    redirect_to root_path
	end

  layout :set_layout

  def set_layout
    (request.xhr?) ? false : 'application'
  end

  before_filter :set_current_user

  def set_current_user
    @current_user ||= login_from_session
  end

	def login_required
		if @current_user.blank?
      # store_location
      flash[:notice] = "로그인 후 사용하실 수 있습니다."
			access_denied
		end
	end

	def access_denied
    redirect_to signin_path and return
	end

  def login_from_session
    begin
      @current_user = User.find(session[:user_id])
    rescue
      @current_user = nil
      session[:user_id] = nil
    end
  end

  def store_location
    session[:return_to] = request.path
  end

  def redirect_back_or(default = "/")
    return_to = session.delete(:return_to) || default
    redirect_to return_to and return
  end

end
