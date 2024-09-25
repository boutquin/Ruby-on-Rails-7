# Define the SessionsController class, inheriting from ApplicationController.
# This controller manages user session actions, such as sign-in and sign-out.
# It is responsible for authenticating users and maintaining session state.
class SessionsController < ApplicationController
  # ============================================================================
  # New Action
  # ============================================================================
  # This action renders the sign-in form. It does not require any instance variables
  # since the form will initialize a new session for the user.
  #
  # Returns:
  # - A view that allows the user to input their email/username and password for
  # authentication.
  def new
  end

  # ============================================================================
  # Create Action
  # ============================================================================
  # This action handles the sign-in process. It attempts to find a user by their
  # email or username and checks if the provided password is correct. If successful,
  # the user's ID is stored in the session, and the user is redirected to their
  # intended page.
  #
  # If the authentication fails (invalid email/username or password), an error
  # message is displayed, and the sign-in form is re-rendered.
  #
  # Returns:
  # - Redirects to the user's intended URL or profile upon successful sign-in.
  # - Renders the 'new' template with an error message if authentication fails.
  def create
    # Attempt to find the user by the email or username provided in the form.
    user = User.find_by(email: params[:email_or_username]) ||
      User.find_by(username: params[:email_or_username])

    # Check if the user exists and if the password is valid.
    if user && user.authenticate(params[:password])
      # Store the user's ID in the session to maintain the authenticated state.
      session[:user_id] = user.id

      # Redirect to the intended URL (or user's profile if none is set) with a welcome message.
      redirect_to (session[:intended_url] || user),
                   notice: "Welcome back, #{user.name}!"

      # Clear the intended URL from the session after successful sign-in.
      session[:intended_url] = nil
    else
      # If authentication fails, set a flash alert message to inform the user.
      flash.now[:alert] = "Invalid (email or username)/password combination!"

      # Re-render the sign-in form with an unprocessable entity status to show errors.
      render :new, status: :unprocessable_entity
    end
  end

  # ============================================================================
  # Destroy Action
  # ============================================================================
  # This action handles user sign-out. It clears the user ID from the session,
  # effectively logging the user out. After signing out, the user is redirected
  # to the movies index page with a confirmation message.
  #
  # Returns:
  # - Redirects to the movies URL, indicating that the user has successfully signed out.
  def destroy
    # Clear the user ID from the session, logging the user out.
    session[:user_id] = nil

    # Redirect to the movies index page with a success message indicating the user is signed out.
    redirect_to movies_url, status: :see_other,
      notice: "You're now signed out!"
  end
end
