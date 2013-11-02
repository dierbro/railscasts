class ApplicationController < ActionController::API
  include CanCan::ControllerAdditions
  include ActionController::Cookies

#  protect_from_forgery
  enable_authorization do |exception|
    redirect_to root_url, :alert => exception.message
  end

  # Hack to make cancan work with rails4 -> https://github.com/ryanb/cancan/issues/835
  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  protected
  # Renders a 401 status code if the current user is not authorized
  def ensure_authenticated_user
    head :unauthorized unless current_user
  end

  # Returns the active user associated with the access token if available
  def current_user
    api_key = ApiKey.active.where(access_token: token).first
    if api_key
      return api_key.user
    else
      return nil
    end
  end
  helper_method :current_user

  # Parses the access token from the header
  def token
    bearer = request.headers["HTTP_AUTHORIZATION"]

    # allows our tests to pass
    bearer ||= request.headers["rack.session"].try(:[], 'Authorization')

    if bearer.present?
      bearer.split.last
    else
      nil
    end
  end
  # overrides ActionController::RequestForgeryProtection#handle_unverified_request
  def handle_unverified_request
    super
    cookies.delete(:token)
  end

  private

  def user_for_paper_trail
    current_user && current_user.id
  end


  def redirect_to_target_or_default(default, *options)
    redirect_to(session[:return_to] || default, *options)
    session[:return_to] = nil
  end

  def store_target_location
    session[:return_to] = request.url
  end
end
