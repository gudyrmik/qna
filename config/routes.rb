Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  concern :likes do
    member do
      patch :like
      patch :dislike
      delete :discard_like
    end
  end

  resources :questions, concerns: :likes do
    delete :delete_attachment, on: :member

    resources :answers, concerns: :likes, shallow: true, only: [:create, :destroy, :update] do
      member do
        post :mark_as_best
        delete :delete_attachment
      end
    end
  end

  resources :links, only: :destroy
  resources :rewards, only: :index
end
