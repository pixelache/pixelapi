Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount_devise_token_auth_for 'User', at: 'auth', controllers: { confirmations: 'api/v1/confirmations', sessions: 'api/v1/sessions', registrations: 'api/v1/registrations', token_validations: 'api/v1/token_validations'}, defaults: { format: :json }

  scope module: 'api' do
    namespace :v1 do
      resources :festivals do
        resources :posts
        member do
          get '/*page', action: :page, as: :festival_page
        end
      end
      resources :opencalls do
        resources :opencallsubmissions
      end
      resources :pages
    end
  end
  root to: 'api/v1/api#home'
end
