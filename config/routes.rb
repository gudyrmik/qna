Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions do
    delete :delete_attachment, on: :member

    resources :answers, shallow: true, only: [:create, :destroy, :update] do
      member do
        post :mark_as_best
        delete :delete_attachment
      end
    end
  end

  resources :links, only: :destroy
  resources :rewards, only: :index
end
