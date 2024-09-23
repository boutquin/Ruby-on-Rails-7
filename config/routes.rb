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
  # Resources for Movies
  # ============================================================================
  # The 'resources' method generates RESTful routes for the 'movies' resource, similar to the 'reviews' resource above.
  #
  # Generated Routes:
  # - GET    /movies          => movies#index   (list all movies)
  # - GET    /movies/new      => movies#new     (form for a new movie)
  # - POST   /movies          => movies#create  (create a new movie)
  # - GET    /movies/:id      => movies#show    (show a specific movie)
  # - GET    /movies/:id/edit => movies#edit    (form to edit a movie)
  # - PATCH  /movies/:id      => movies#update  (update a specific movie)
  # - PUT    /movies/:id      => movies#update  (alternative to PATCH)
  # - DELETE /movies/:id      => movies#destroy (delete a specific movie)
  #
  # Notes:
  # - These routes provide full CRUD functionality for movies.
  # - The routes map HTTP verbs and URLs to controller actions in the 'MoviesController'.
  resources :movies

  # ============================================================================
  # Resources for Reviews
  # ============================================================================
  # The 'resources' method automatically creates RESTful routes for a resource.
  # For the 'reviews' resource, it generates the following routes:
  # - GET    /reviews          => reviews#index   (list all reviews)
  # - GET    /reviews/new      => reviews#new     (form for a new review)
  # - POST   /reviews          => reviews#create  (create a new review)
  # - GET    /reviews/:id      => reviews#show    (show a specific review)
  # - GET    /reviews/:id/edit => reviews#edit    (form to edit a review)
  # - PATCH  /reviews/:id      => reviews#update  (update a specific review)
  # - PUT    /reviews/:id      => reviews#update  (alternative to PATCH)
  # - DELETE /reviews/:id      => reviews#destroy (delete a specific review)
  #
  # These routes provide a full set of CRUD (Create, Read, Update, Delete) actions for reviews.
  resources :reviews
end
