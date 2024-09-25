# Define the UsersController class, inheriting from ApplicationController.
# This controller manages user-related actions such as registration,
# profile editing, and user account management. By inheriting from
# ApplicationController, it gains access to shared methods and filters,
# such as authentication and authorization mechanisms.
class UsersController < ApplicationController
  # ============================================================================
  # Before Actions
  # ============================================================================
  # The before_action callbacks are executed before the specified actions in the controller.
  # These are used to enforce authentication and authorization.

  # Require users to be signed in for all actions except 'new' (registration)
  # and 'create' (user account creation).
  before_action :require_signin, except: [ :new, :create ]

  # Ensure the current user is the correct user for actions that modify user data.
  before_action :require_correct_user, only: [ :edit, :update, :destroy ]

  # ============================================================================
  # Index Action
  # ============================================================================
  # This action retrieves all users in the application and assigns them to the
  # instance variable @users, making it available to the corresponding view.
  #
  # Returns:
  # - @users: An array of User objects representing all users in the database.
  def index
    @users = User.all
  end

  # ============================================================================
  # Show Action
  # ============================================================================
  # This action finds a specific user by their ID and assigns them to the
  # instance variable @user for display in the corresponding view.
  #
  # Raises:
  # - ActiveRecord::RecordNotFound if no user is found with the given ID.
  #
  # Returns:
  # - @user: An instance of User representing the user with the specified ID.
  def show
    @user = User.find_by id: params[:id]
  end

  # ============================================================================
  # New Action
  # ============================================================================
  # This action initializes a new user object and assigns it to @user.
  # This object is used in the registration form for a new user.
  #
  # Returns:
  # - @user: A new instance of User, which is empty and ready for input.
  def new
    @user = User.new
  end

  # ============================================================================
  # Create Action
  # ============================================================================
  # This action creates a new user based on the parameters submitted through the
  # registration form. If the user is saved successfully, the user's ID is stored
  # in the session, and the user is redirected to their profile page with a success message.
  #
  # If saving the user fails (due to validation errors), the 'new' view is rendered
  # again with the errors displayed.
  def create
    @user = User.new(user_params)
    if @user.save
      # Store the new user's ID in the session for authentication.
      session[:user_id] = @user.id
      # Redirect to the user's profile with a success notice.
      redirect_to @user, notice: "Thanks for signing up!"
    else
      # Render the 'new' template with validation errors and an unprocessable entity status.
      render :new, status: :unprocessable_entity
    end
  end

  # ============================================================================
  # Edit Action
  # ============================================================================
  # This action is used to display the edit form for the current user.
  # The instance variable @user is already set by the require_correct_user
  # method, ensuring that the correct user is being edited.
  def edit
  end

  # ============================================================================
  # Update Action
  # ============================================================================
  # This action updates the current user's information based on the submitted
  # parameters. If the update is successful, the user is redirected to their
  # profile page with a success message. If it fails, the edit form is rendered
  # again with the validation errors.
  def update
    if @user.update(user_params)
      # Redirect to the user's profile with a success notice.
      redirect_to @user, notice: "Account successfully updated!"
    else
      # Render the 'edit' template with validation errors and an unprocessable entity status.
      render :edit, status: :unprocessable_entity
    end
  end

  # ============================================================================
  # Destroy Action
  # ============================================================================
  # This action deletes the current user's account. After deletion, the user ID
  # is removed from the session, logging them out. The user is then redirected
  # to the movies index page with a success alert.
  def destroy
    @user.destroy

    # Clear the user ID from the session.
    session[:user_id] = nil

    # Redirect to the movies index page with a success alert.
    redirect_to movies_url, status: :see_other,
      alert: "Account successfully deleted!"
  end

  # ============================================================================
  # Private Methods
  # ============================================================================
  # The 'private' keyword marks all subsequent methods as private.
  # Private methods are internal helper methods and cannot be accessed externally (e.g., via a URL).
  private

  # ============================================================================
  # Require Correct User Method
  # ============================================================================
  # This method checks if the user attempting to access the edit, update, or
  # destroy actions is indeed the current user. If not, the user is redirected
  # to the root URL with a status indicating the action was redirected due to
  # unauthorized access.
  #
  # Raises:
  # - ActiveRecord::RecordNotFound if no user is found with the given ID.
  def require_correct_user
    @user = User.find_by id: params[:id]
    # Redirect to root if the current user does not match the user being edited or deleted.
    redirect_to root_url, status: :see_other unless current_user?(@user)
  end

  # ============================================================================
  # User Parameters Method
  # ============================================================================
  # This method filters the parameters submitted to the create and update actions
  # to ensure only permitted attributes are allowed. This is a security measure
  # to prevent mass assignment vulnerabilities.
  #
  # Returns:
  # - A hash of permitted parameters for user creation and updates, including:
  #   - :name
  #   - :email
  #   - :password
  #   - :password_confirmation
  def user_params
    params.require(:user).
      permit(:name, :email, :password, :password_confirmation)
  end
end
