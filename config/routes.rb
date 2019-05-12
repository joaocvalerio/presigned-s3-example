Rails.application.routes.draw do

  namespace :v1, as: nil do
    get '/' => 'status#ping'

    devise_for :users, defaults: { format: :json },
      controllers: {
        registrations: 'v1/users/registrations',
        sessions: 'v1/users/sessions',
        passwords: 'v1/users/passwords',
      }
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
