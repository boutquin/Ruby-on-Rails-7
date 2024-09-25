# Define the ApplicationController class, which inherits from ActionController::Base.
# This serves as the base controller for all controllers in the application.
# By inheriting from ActionController::Base, it provides access to all the features
# of Action Controller, enabling the handling of web requests, rendering views, and
# managing sessions.
class ApplicationController < ActionController::Base
  # ============================================================================
  # Browser Support Configuration
  # ============================================================================
  # This line specifies that the application only allows modern browsers to access it.
  # The criteria for 'modern' browsers include support for:
  # - WebP images for optimized image formats.
  # - Web Push Notifications for sending notifications to users even when the application is not open.
  # - Badges, which are small icons for visual notifications.
  # - Import Maps, enabling JavaScript module imports without a bundler.
  # - CSS Nesting, allowing nested CSS rules for more organized stylesheets.
  # - CSS :has pseudo-class, enabling conditional styling based on the presence of child elements.
  allow_browser versions: :modern

  # ============================================================================
  # Private Methods
  # ============================================================================
  # The 'private' keyword marks all subsequent methods as private.
  # Private methods are internal helper methods and cannot be accessed externally (e.g., via a URL).
  private

  # ============================================================================
  # Require User Sign-in Method
  # ============================================================================
  # This method ensures that the user is signed in before allowing access to certain actions.
  # If the user is not signed in, they are redirected to the sign-in page.
  #
  # The intended URL (the page the user was trying to access) is stored in the session,
  # allowing the application to redirect them back after successful sign-in.
  def require_signin
    unless current_user
      # Store the current request URL in the session for later redirection.
      session[:intended_url] = request.url
      # Redirect to the sign-in page with an alert message.
      redirect_to new_session_url, alert: "Please sign in first!"
    end
  end

  # ============================================================================
  # Current User Method
  # ============================================================================
  # This method retrieves the currently signed-in user based on the user ID stored in the session.
  # It memoizes the result, meaning that the user will only be fetched from the database
  # once per request, improving performance by avoiding multiple database calls.
  def current_user
    @current_user ||= User.find_by id: session[:user_id] if session[:user_id]
  end

  # Make the current_user method available in views as a helper method.
  helper_method :current_user

  # ============================================================================
  # Current User Comparison Method
  # ============================================================================
  # This method checks if the given user object is the currently signed-in user.
  #
  # Parameters:
  # - user: An instance of User to compare against the current user.
  #
  # Returns:
  # - true if the provided user is the current user, false otherwise.
  def current_user?(user)
    current_user == user
  end

  # Make the current_user? method available in views as a helper method.
  helper_method :current_user?

  # ============================================================================
  # Require Admin Privileges Method
  # ============================================================================
  # This method checks if the current user has admin privileges.
  # If the user is not an admin, they are redirected to the root URL with an alert message.
  def require_admin
    unless current_user_admin?
      redirect_to root_url, alert: "Unauthorized access!"
    end
  end

  # ============================================================================
  # Current User Admin Check Method
  # ============================================================================
  # This method verifies whether the currently signed-in user has admin rights.
  #
  # Returns:
  # - true if the current user exists and has admin rights, false otherwise.
  def current_user_admin?
    current_user && current_user.admin?
  end

  # Make the current_user_admin? method available in views as a helper method.
  helper_method :current_user_admin?
end
