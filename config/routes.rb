Rails.application.routes.draw do

  # GET /users/sign_in/ (devise/sessions#new)
  # POST /users/sign_in/ (devise/sessions#create)
  # DELETE /users/sign_out/ (devise/sessions#destroy)
  # GET /users/password/new (devise/passwords#new)
  # GET /users/password/edit (devise/passwords#edit)
  # PATCH /users/password/ (devise/passwords#update)
  # PUT /users/password/ (devise/passwords#update)
  # POST /users/password/ (devise/passwords#create)

  # GET /users/cancel (registrations#cancel)
  # GET /users/sign_up (registrations#new)
  # GET /users/edit (registrations#edit)
  # PATCH /users (registrations#udpate)
  # PUT /users (registrations#udpate)
  # DELETE /users (registrations#destroy)
  # POST /users (registrations#create)
  devise_for :users, controllers: { registrations: 'registrations' }

  # GET / (projects#index)
  authenticated :user do
    root 'projects#index', as: :authenticated_root
  end



  # PATCH /projects/id/complete (projects#complete)
  # GET /projects/ (projects#index)
  # POST /projects/ (projects#create)
  # GET /projects/new (projects#new)
  # GET /projects/id/edit (projects#edit)
  # GET /projects/id/ (projects#show)
  # PATCH /projects/id/ (projects#update)
  # PUT /projects/id/ (projects#update)
  # DELETE /projects/id/ (projects#destroy)
  resources :projects do
    # GET /projects/:project_id/notes (notes#index)
    # POST /projects/:project_id/notes (notes#create)
    # GET /projects/:project_id/notes/new (notes#new)
    # GET /projects/:project_id/notes/id/edit (notes#edit)
    # GET /projects/:project_id/notes/id (notes#show)
    # PATCH /projects/:project_id/notes/id (notes#update)
    # PUT /projects/:project_id/notes/id (notes#update)
    # DELETE /projects/:project_id/notes/id (notes#destroy)
    resources :notes
    # POST /projects/project_id/tasks/id/toggle (tasks#toggle)
    # GET /projects/project_id/tasks (tasks#index)
    # POST /projects/project_id/tasks (tasks#create)
    # GET /projects/project_id/tasks/new (tasks#new)
    # GET /projects/project_id/tasks/id/edit (tasks#edit)
    # GET /projects/project_id/tasks/id (tasks#show)
    # PATCH /projects/project_id/tasks/id (tasks#update)
    # PUT /projects/project_id/tasks/id (tasks#update)
    # DELETE /projects/project_id/tasks/id (tasks#destroy)
    resources :tasks do
      member do
        post :toggle
      end
    end
    member do
      patch :complete
    end
  end

  # GET /api/projects (api/projects#index)
  # POST /api/projects (api/projects#create)
  # GET /api/projects/new (api/projects#new)
  # GET /api/projects/id/edit (api/projects#edit)
  # GET /api/projects/id (api/projects#show)
  # PATCH /api/projects/id (api/projects#update)
  # PUT /api/projects/id (api/projects#update)
  # DELETE /api/projects/id (api/projects#destroy)
  namespace :api do
    resources :projects #, only: [:index, :show, :create]
  end

  root "home#index"
end
