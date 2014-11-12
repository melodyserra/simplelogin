class AccessController < ApplicationController
	before_action :prevent_not_logged_in, only: [:home]
	before_action :prevent_login_signup, only: [:login, :signup]

  def signup
  	@user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "You are now logged in"
      redirect_to home_path
    else
      render :signup
    end
  end

  def login
  end

  def attempt_login
  	if params[:username].present? && params[:password].present?
  		found_user = User.where(username: params[:username]).first
			if found_user
	 			authorized_user = found_user.authenticate(params[:password])
	  		if authorized_user
	  			flash[:success] = "You have logged in successfully"
	  			session[:user_id] = authorized_user.id 
	  			redirect_to home_path
	  			# logged in correctly
	  		else
	  			flash.now[:alert] = "Incorrect password"
					render :login
	  		end
			else 
				flash.now[:alert] = "Incorrect username"
				render :login
			end
		else 
			flash.now[:alert] = "Need to specify a username and password"
			render :login
		end
  end

	def home
	end


  def logout
  	session[:user_id] = nil
  	flash[:success] = "You have logged out successfully"
  	redirect_to login_path
  end

  private
  def user_params
    params.require(:user).permit(:username, :password, :password_digest)
  end
  def prevent_login_signup
  	if session[:user_id]
  		redirect_to home_path
  	end
  end
  def prevent_not_logged_in
  	if !session[:user_id]
  		redirect_to login_path
  	end
  end

end
