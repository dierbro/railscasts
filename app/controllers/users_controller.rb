class UsersController < ApplicationController
  include ActionController::MimeResponds

  before_filter :load_current_user, :only => [:edit, :update]
  load_and_authorize_resource

  def show
    render json: @user
  end

  def create
    omniauth = request.env["omniauth.auth"]
    logger.info omniauth.inspect
    @user = User.find_by_github_uid(omniauth["uid"]) || User.create_from_omniauth(omniauth)
    cookies.permanent[:token] = @user.token
    #window.opener.Discourse.authenticationComplete({"email":"","name":"Dierbro","username":"dierbro1","auth_provider":"Github","email_valid":true});
    #            window.close();
#    redirect_to_target_or_default root_url, :notice => "Signed in successfully"
    if @user.new_record?
      render json: { errors: @user.errors.messages }, status: 422
    else
      render text: JsGenerator.after_login(@user.session_api_key, @user.id)
    end
  end

  def edit
  end

  def update
    @user.attributes = user_params
    @user.save!
    #redirect_to @user, :notice => "Successfully updated profile."
    render json: @user.session_api_key, status: 201
  end

  def login
    session[:return_to] = params[:return_to] if params[:return_to]
    if Rails.env.development?
      cookies.permanent[:token] = User.first.token
      redirect_to_target_or_default root_url, :notice => "Signed in successfully"
    else
      redirect_to "/auth/github"
    end
  end

  def logout
    cookies.delete(:token)
    redirect_to root_url, :notice => "You have been logged out."
  end

  def ban
    @user = User.find(params[:id])
    @user.update_attribute(:banned_at, Time.now)
    @comments = @user.comments
    @comments.each(&:destroy)
    respond_to do |format|
      format.html { redirect_to :back, :notice => "User #{@user.name} has been banned." }
      format.js
    end
  end

  def unsubscribe
    @user = User.find_by_unsubscribe_token!(params[:token])
    @user.update_attributes!(:email_on_reply => false)
    redirect_to root_url, :notice => "You have been unsubscribed from further email notifications."
  end

  private

  def load_current_user
    @user = current_user
  end
  
  def user_params
    params.require(:user).permit(:email, :email_on_reply, :name, :site_url)
  end
end
