# The 'routes.rb' file is a crucial part of a Ruby on Rails application.
# It defines the mapping between URLs (HTTP requests) and controller actions (code that handles the requests).
# This file uses a domain-specific language (DSL) provided by Rails to specify routes in a clear and concise manner.

Rails.application.routes.draw do
  # ============================================================================
  # General Routing Guide
  # ============================================================================
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # The above comment is a reference to the Rails routing guide, which provides detailed information
  # on how to define routes, use route helpers, and customize routing behavior.

  # ============================================================================
  # Health Check Route
  # ============================================================================
  # The following route exposes a health check endpoint at '/up'.
  # When accessed, it returns a 200 OK status if the application has booted without exceptions.
  # Otherwise, it returns a 500 Internal Server Error.
  # This route is useful for load balancers and uptime monitoring tools to verify that the application is live.
  #
  # Route Details:
  # - HTTP Verb: GET
  # - Path: /up
  # - Controller#Action: rails/health#show
  # - Named Route Helper: rails_health_check_path
  #
  # Notes:
  # - 'rails/health#show' refers to the 'show' action in the 'Rails::HealthController' namespace.
  # - The 'as:' option assigns a name to the route, allowing you to use 'rails_health_check_path' in your code.
  get "up" => "rails/health#show", as: :rails_health_check

  # ============================================================================
  # Progressive Web App (PWA) Routes
  # ============================================================================
  # These routes are for serving dynamic PWA-related files from the 'app/views/pwa/' directory.
  # PWAs enhance web applications with features like offline support and improved performance.

  # Route for the Service Worker
  # --------------------------------
  # The service worker is a script that runs in the background, separate from the web page,
  # enabling features like offline caching and push notifications.
  #
  # Route Details:
  # - HTTP Verb: GET
  # - Path: /service-worker
  # - Controller#Action: rails/pwa#service_worker
  # - Named Route Helper: pwa_service_worker_path
  #
  # Notes:
  # - The 'rails/pwa#service_worker' action serves the service worker JavaScript file.
  # - The 'as:' option creates a URL helper for this route.
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Route for the Web App Manifest
  # --------------------------------
  # The web app manifest provides metadata about the application, such as icons, theme colors,
  # and how it should appear when installed on a user's device.
  #
  # Route Details:
  # - HTTP Verb: GET
  # - Path: /manifest
  # - Controller#Action: rails/pwa#manifest
  # - Named Route Helper: pwa_manifest_path
  #
  # Notes:
  # - The 'rails/pwa#manifest' action serves the manifest JSON file.
  # - The 'as:' option creates a URL helper for this route.
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # ============================================================================
  # Root Route
  # ============================================================================
  # The root route defines the default page that is loaded when a user visits the base URL of the application (e.g., http://www.example.com/).
  #
  # Route Details:
  # - HTTP Verb: GET
  # - Path: /
  # - Controller#Action: movies#index
  #
  # Notes:
  # - This route directs the root URL to the 'index' action of the 'MoviesController'.
  # - It effectively makes the movies index page the home page of the application.
  root "movies#index"

# Define a RESTful resource for the session in the application's routing configuration.
# This resource is used to manage user authentication and session management.

# The 'resource' method defines a singular resource, indicating that there will be only
# one instance of the session at any time, rather than multiple instances like with a
# traditional resource. This is suitable for session management because a user can only
# be logged in once at a time in a typical web application.

# ============================================================================
# Session Resource
# ============================================================================

# This line creates routes for managing user sessions, allowing users to sign in
# and sign out of the application. The routes are limited to the following actions:
# - new: Displays the sign-in form for the user.
# - create: Processes the sign-in form submission and creates a new session if the user
#           is authenticated successfully.
# - destroy: Logs the user out by destroying the session.

resource :session, only: [ :new, :create, :destroy ] do
  # The 'only' option restricts the routes generated for this resource to just the specified
  # actions, which improves clarity and security by preventing unintended routes from being created.

  # This will generate the following routes:
  # - GET /session/new => sessions#new
  #   This route maps to the 'new' action in the SessionsController, allowing the user to
  #   view the sign-in form. It's typically accessed by navigating to the sign-in page.

  # - POST /session => sessions#create
  #   This route maps to the 'create' action in the SessionsController. It handles the
  #   submission of the sign-in form. If the credentials are valid, the session is created,
  #   and the user is redirected accordingly. If invalid, an error message is shown.

  # - DELETE /session => sessions#destroy
  #   This route maps to the 'destroy' action in the SessionsController. It is used for
  #   logging the user out by deleting the session. The user is then redirected to an
  #   appropriate page (usually the homepage or a login page), confirming that they have
  #   been signed out.
end

  # Define a custom route for user sign-in in the application's routing configuration.
  # This route allows users to access the sign-in form where they can enter their
  # credentials to log into the application.

  # ============================================================================
  # Sign-in Route
  # ============================================================================

  # The following line defines a GET route for the "signin" path. When a user navigates
  # to "/signin", this route will be triggered, leading to the rendering of the
  # sign-in form.

  get "signin" => "sessions#new"

  # This route maps to the 'new' action of the SessionsController.
  # The specific components of this route are as follows:

  # - GET "signin":
  #   This indicates that the route responds to GET HTTP requests. The purpose of a
  #   GET request is to retrieve data from the server, which, in this case, is
  #   the sign-in form that users will fill out to log into their accounts.

  # - "sessions#new":
  #   This part specifies the controller and action that will handle the request.
  #   - "sessions" refers to the SessionsController, which is responsible for
  #     managing user sessions, including signing in and signing out.
  #   - "new" is the action within the SessionsController that prepares and
  #     displays the sign-in form. It does not take any parameters from the URL
  #     and typically initializes a new session object if necessary.

  # ============================================================================
  # Purpose and Usage
  # ============================================================================

  # This route is crucial for user authentication, as it serves as the entry point
  # for users to access the application after they have registered. The sign-in
  # form generated by the 'new' action will prompt the user for their email
  # and password, which will then be submitted to the 'create' action to attempt
  # logging them in.

  # It is also common to provide a link or button on the application's homepage
  # or navigation menu that directs users to this sign-in route, ensuring that
  # logging in is easily accessible.

  # Overall, this route is essential for enabling users to access their accounts
  # and interact with the application's features.

  # This line defines a route in the application's routing configuration.
  # It maps HTTP DELETE requests sent to the "signout" path to the `destroy` action
  # of the `SessionsController`. This route is responsible for handling user sign-out
  # functionality, allowing users to log out of the application.

  # Route Definition:
  # The `delete` method is used here to specify that this route will respond to
  # DELETE HTTP requests. This is a RESTful approach, as it aligns with the
  # standard conventions for managing resources—specifically, for signing out
  # of a session, which is considered a destructive action.

  # URL Pattern:
  # - The URL pattern defined by this route is `/signout`.
  # - When a user navigates to this URL and sends a DELETE request (usually via
  #   a button or link in the user interface), the request is routed to the
  #   SessionsController.

  # Controller Action:
  # - The `destroy` action in the `SessionsController` is invoked when this route
  #   is accessed. This action is responsible for clearing the user's session
  #   data and effectively logging them out of the application.

  # Session Management:
  # - The `destroy` action will typically include logic to:
  #   1. Clear the session by setting `session[:user_id] = nil`. This removes
  #      any identification of the current user, thus ending the session
  #   2. Redirect the user to a designated page (often the homepage or a login
  #      page) after sign-out, providing feedback (like a success message)
  #      that they have successfully logged out.

  # Security Implications:
  # - Using the DELETE method for signout is important for security reasons.
  #   It helps prevent accidental logouts that could occur if a user were to
  #   click on a GET request link or button.
  # - To ensure that the logout action is performed securely, it's common to
  #   implement confirmation prompts (like a modal) in the user interface, asking
  #   users if they really want to sign out before proceeding.

  # Conclusion:
  # This route provides a clear and secure mechanism for users to log out
  # of the application, following RESTful practices and ensuring proper
  # session management.
  delete "signout" => "sessions#destroy"

  # ============================================================================
  # Signup Route Configuration
  # ============================================================================
  # This route defines the path that users will visit to access the
  # sign-up page for creating a new account in the application.
  #
  # The route uses the `get` HTTP method, indicating that this route
  # will respond to GET requests. A GET request is typically used
  # to retrieve and display a resource without making any changes
  # to the server's state.
  get "signup" => "users#new"

  # ============================================================================
  # Route Details:
  # - HTTP Verb: GET
  #   The GET method is used here because we want to retrieve and
  #   display the sign-up form to the user. This is the standard
  #   method for rendering a web page without altering server-side
  #   data.
  #
  # - Path: /signup
  #   This is the URL that users will navigate to in order to
  #   access the sign-up form. It is a user-friendly and intuitive
  #   path that clearly indicates its purpose, making it easy for
  #   users to find the sign-up feature.
  #
  # - Controller#Action: users#new
  #   This notation specifies that the request will be handled
  #   by the `new` action within the `UsersController`. The `new`
  #   action is typically responsible for initializing a new user
  #   object and rendering the sign-up form.
  #
  #   The `UsersController` is likely where user-related actions
  #   are defined, including creating, updating, and deleting users.
  #
  #   The `new` action prepares the necessary instance variables
  #   (if any) and presents the form for the user to fill out.
  #
  #   Example of Typical Implementation in UsersController:
  #   class UsersController < ApplicationController
  #     def new
  #       @user = User.new
  #       # This initializes a new User object that will be used in the form.
  #       # The form will be populated with this new user instance to collect
  #       # user input such as name, email, and password.
  #     end
  #   end
  #
  # ============================================================================
  # Named Route Helper:
  # - The route defined above will automatically create a named helper method
  #   that can be used throughout the application to generate the path to this
  #   route. By default, the helper method will be `signup_path` or
  #   `signup_url`.
  #
  #   Example Usage:
  #   - In a view or controller, you can use:
  #     <%= link_to "Sign Up", signup_path %>
  #     This generates a link that directs users to the sign-up page.
  #
  #   - You can also use this helper in redirects:
  #     redirect_to signup_path
  #     This redirects users to the sign-up page programmatically.
  #
  # ============================================================================
  # Important Notes:
  # - The `signup` route is a crucial part of user registration flow.
  #   It should be easily accessible from other parts of the application,
  #   such as the home page or login page, allowing new users to
  #   register easily.
  #
  # - Considerations for Security and Usability:
  #   - Ensure that the sign-up form includes validations and error
  #     handling to provide feedback to the user in case of invalid input.
  #   - It may also be beneficial to include additional information
  #     about the benefits of signing up or the features available
  #     to registered users, enhancing user engagement and conversion.
  #
  # - As the application evolves, this route may be modified to
  #   incorporate additional features such as social sign-ups,
  #   CAPTCHA for spam prevention, or terms of service agreements.
  #
  # Overall, this route sets the foundation for user account creation,
  # and it is vital that it is designed with user experience and security
  # considerations in mind.

  # ============================================================================
  # Resources for Movies (with Nested Reviews)
  # ============================================================================
  # The 'resources' method generates RESTful routes for the 'movies' resource.
  # By nesting 'reviews' within 'movies', we create routes that reflect the hierarchical relationship between movies and reviews.
  #
  # Nested Resources:
  # - Indicates that reviews are a sub-resource of movies.
  # - Allows us to access reviews in the context of a specific movie.
  #
  # Generated Routes for Movies:
  # - GET    /movies          => movies#index   (list all movies)
  # - GET    /movies/new      => movies#new     (form for a new movie)
  # - POST   /movies          => movies#create  (create a new movie)
  # - GET    /movies/:id      => movies#show    (show a specific movie)
  # - GET    /movies/:id/edit => movies#edit    (form to edit a movie)
  # - PATCH  /movies/:id      => movies#update  (update a specific movie)
  # - PUT    /movies/:id      => movies#update  (alternative to PATCH)
  # - DELETE /movies/:id      => movies#destroy (delete a specific movie)
  #
  # Generated Nested Routes for Reviews:
  # - GET    /movies/:movie_id/reviews          => reviews#index   (list all reviews for a movie)
  # - GET    /movies/:movie_id/reviews/new      => reviews#new     (form for a new review for a movie)
  # - POST   /movies/:movie_id/reviews          => reviews#create  (create a new review for a movie)
  # - GET    /movies/:movie_id/reviews/:id      => reviews#show    (show a specific review for a movie)
  # - GET    /movies/:movie_id/reviews/:id/edit => reviews#edit    (form to edit a review for a movie)
  # - PATCH  /movies/:movie_id/reviews/:id      => reviews#update  (update a specific review for a movie)
  # - PUT    /movies/:movie_id/reviews/:id      => reviews#update  (alternative to PATCH)
  # - DELETE /movies/:movie_id/reviews/:id      => reviews#destroy (delete a specific review for a movie)
  #
  # Notes:
  # - The nested routes provide a way to handle reviews in the context of a specific movie.
  # - URL patterns include the movie ID, reflecting the parent-child relationship.
  # - Named route helpers are generated accordingly, e.g.,
  #   - movie_reviews_path(@movie): path to the index of reviews for a movie.
  #   - new_movie_review_path(@movie): path to the form for creating a new review for a movie.
  #   - edit_movie_review_path(@movie, @review): path to the form for editing a review.
  resources :movies do
    resources :reviews
  end

  # ============================================================================
  # Resources for Users
  # ============================================================================
  # The 'resources' method generates RESTful routes for the 'users' resource.
  # This allows for standard actions related to user management, such as creating,
  # reading, updating, and deleting user records.
  #
  # Generated Routes for Users:
  # - GET    /users          => users#index   (list all users)
  # - GET    /users/new      => users#new     (form for creating a new user)
  # - POST   /users          => users#create  (create a new user)
  # - GET    /users/:id      => users#show    (show a specific user)
  # - GET    /users/:id/edit => users#edit    (form to edit a user)
  # - PATCH  /users/:id      => users#update  (update a specific user)
  # - PUT    /users/:id      => users#update  (alternative to PATCH)
  # - DELETE /users/:id      => users#destroy (delete a specific user)
  #
  # Notes:
  # - The generated routes follow RESTful conventions, providing a clear and
  #   organized way to manage user data.
  # - Each route corresponds to a specific controller action in the UsersController,
  #   allowing for a separation of concerns and adherence to the MVC architecture.
  # - Named route helpers are generated for each route, enabling easier reference
  #   in views and controllers. For example:
  #   - users_path: path to the index of users.
  #   - new_user_path: path to the form for creating a new user.
  #   - user_path(@user): path to show a specific user.
  #   - edit_user_path(@user): path to the form for editing a specific user.
  #   - The use of the :id parameter in routes facilitates access to specific user records.
  resources :users

  # ============================================================================
  # Additional Routes (If Any)
  # ============================================================================
  # If you have other resources or custom routes, they can be defined here.
  # For example, if you have an 'actors' resource:
  # resources :actors
end
