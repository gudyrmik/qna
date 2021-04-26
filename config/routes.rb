Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: "questions#index"

  concern :likable do
    member do
      patch :like
      patch :dislike
      delete :discard_like
    end
  end

  concern :commentable do
    post :create_comment, on: :member
  end

  resources :questions, concerns: %i[likable commentable] do
    delete :delete_attachment, on: :member

    resources :answers, concerns: %i[likable commentable], shallow: true, only: [:create, :destroy, :update] do
      member do
        post :mark_as_best
        delete :delete_attachment
      end
    end
  end

  resources :links, only: :destroy
  resources :rewards, only: :index
end
