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
