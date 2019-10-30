Rails.application.routes.draw do
  devise_for :employees
  devise_for :candidates

  root to: 'home#index'

  resources :companies, only: %i[index edit update show] do
    collection do
      get 'dashboard'
      get 'invites'
      get 'selection_processes'
    end
  end
  resources :company_profiles, only: %i[new create edit update]
  resources :candidates, only: %i[index show] do
    member do
      post 'add-comment', to: 'candidates#add_comment', as: :add_comment
      post 'invite', to: 'candidates#invite'
    end

    collection do
      get 'dashboard'
      get 'invites'
    end

    post 'invites/accept/:id', to: 'candidates#accept_invite', on: :member, as: :accept_invites
    post 'invites/reject/:id', to: 'candidates#reject_invite', on: :member, as: :reject_invites
    get 'invites/select_process/:id', to: 'selection_processes#show', on: :collection, as: :selection_process
    post 'invites/select_process/:id', to: 'selection_processes#send_message', on: :collection, as: :send_message
  end

  resources :positions, only: %i[new create show]
  resources :candidate_profiles, only: %i[new create edit update]

  get 'my_company', to: 'company#my_company'
end
