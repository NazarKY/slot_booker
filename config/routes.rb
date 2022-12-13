Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'slots/index'
      post 'slots/create'
    end
  end
  mount ActionCable.server => '/cable'

  root 'homepage#index'
  get '/*path' => 'homepage#index'
end
