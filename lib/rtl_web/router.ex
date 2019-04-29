# Docs: http://www.phoenixframework.org/docs/routing#section-the-endpoint-plugs
defmodule RTLWeb.Router do
  use RTLWeb, :router
  # Rollbax error handler - see #handle_errors()
  use Plug.ErrorHandler
  import RTLWeb.SessionPlugs, only: [
    load_current_user: 2,
    ensure_logged_in: 2
  ]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_current_user
  end

  scope "/", RTLWeb do
    pipe_through :browser

    get "/", HomeController, :index
    get "/test_error", HomeController, :test_error

    # Routes are organized by functional contexts.
    # Routes are NOT organized by user role, permissions, or scoped resources.
    # The contexts are:
    # - /auth (authentication & session)
    # - /admin (admin & superadmin tools; coding interface)
    # - /projects/:project_uuid/ (tools for getting videos into the db)
    # - /explore (tools for the end user to explore the coded results)

    scope "/auth" do
      # The Ueberauth login route redirects to Auth0's login page
      get "/login", AuthController, :login
      # Auth0 redirects back here after successful auth
      get "/auth0_callback", AuthController, :auth0_callback
      get "/logout", AuthController, :logout
      get "/login_from_uuid/:uuid", AuthController, :login_from_uuid
    end

    #
    # Admin-facing routes (manage structure, code videos, etc.)
    #

    scope "/admin", as: :admin do
      resources "/users", Admin.UserController
      resources "/projects", Admin.ProjectController, param: :uuid

      scope "/projects/:project_uuid", as: :project do
        resources "/prompts", Admin.PromptController, except: [:index]

        resources "/videos", Admin.VideoController, only: [:index]
        scope "/videos/:video_id", as: :video do
          resources "/codings", Process.CodingController,
            only: [:new, :create, :edit, :update]
        end
      end

      # Not scoped under /projects/:id so we can add a join from either direction
      resources "/project_admin_joins", Admin.ProjectAdminJoinController,
        only: [:create, :delete]
    end

    #
    # Public-facing routes (interview recording, explore results, etc.)
    #

    scope "/projects/:project_uuid" do
      get "/", ProjectController, :show

      scope "/share", as: :share do
        scope "/prompts/:prompt_uuid" do
          resources "/from_webcam", Collect.FromWebcamController, only: [:new, :create]
          get "/from_webcam/thank_you", Collect.FromWebcamController, :thank_you
        end
      end

      scope "/explore", as: :explore do
        get "/", ExploreController, :index
        get "/playlist_json", :playlist_json

        get "/videos/:id", Explore.VideoController, :show
      end
    end

    scope "/help", as: :help do
      get "/collecting_videos", HelpController, :collecting_videos
    end

  end

  defp handle_errors(conn, data), do: RTLWeb.RollbarPlugs.handle_errors(conn, data)
end
