class ApplicationController < ActionController::Base

    helper_method :current_user, :logged_in?

    def require_no_user!
        redirect_to cats_url if current_user
    end

     def require_user!
        redirect_to new_session_url if current_user.nil?
    end

    def current_user
        @current_user ||= User.find_by(session_token: session[:session_token])
    end

    def login_user!(user)
        session[:session_token] = user.reset_session_token!
        @current_user = user
    end

    def logged_in?
        !!self.current_user
    end

end
