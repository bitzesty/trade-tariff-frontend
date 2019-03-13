require 'trade_tariff_frontend'

Rails.application.routes.draw do
  scope path: "#{APP_SLUG}" do
    get "/", to: redirect("https://www.gov.uk/trade-tariff", status: 302)
    get "healthcheck", to: "healthcheck#check"
    get "opensearch", to: "pages#opensearch", constraints: { format: :xml }
    get "terms", to: "pages#terms"
    get "cookies", to: "pages#cookies"
    get "exchange_rates", to: "exchange_rates#index"
    get "geographical_areas", to: "geographical_areas#index", as: :geographical_areas
    get 'feedback', to: 'feedback#new'
    post 'feedback', to: 'feedback#create'
    get 'feedback/thanks', to: 'feedback#thanks'

    match "/search", to: "search#search", as: :perform_search, via: [:get, :post]
    get "search_suggestions", to: "search#suggestions", as: :search_suggestions
    match "a-z-index/:letter", to: "search_references#show",
          via: :get,
          as: :a_z_index,
          constraints: { letter: /[a-z]{1}/i }

    constraints TradeTariffFrontend::ApiConstraints.new(
      TradeTariffFrontend.accessible_api_endpoints
    ) do
      match ':endpoint/(*path)',
        via: :get,
        to: TradeTariffFrontend::RequestForwarder.new(
          host: Rails.application.config.api_host,
          api_request_path_formatter: ->(path) {
            path.gsub("#{APP_SLUG}/", "")
          }
        )
    end

    resources :sections, only: [:index, :show]
    resources :chapters, only: [:index, :show] do
      resources :changes,
                only: [:index],
                defaults: { format: :atom },
                module: 'chapters'
    end
    resources :headings, only: [:index, :show] do
      resources :changes,
                only: [:index],
                defaults: { format: :atom },
                module: 'headings'
    end
    resources :commodities, only: [:index, :show] do
      resources :changes,
                only: [:index],
                defaults: { format: :atom },
                module: 'commodities'
    end
  end

  get "v1(/commodities)/goods_nomenclature", to: TradeTariffFrontend::RequestForwarder.new(
    host: Rails.application.config.api_host,
    api_request_path_formatter: ->(path) {
      path.gsub("v1/", "")
    }
  )
  
  scope path: "v1", :format => true, :constraints => { :format => 'json' } do
    constraints TradeTariffFrontend::ApiConstraints.new(
      TradeTariffFrontend.public_api_endpoints
    ) do
      match ':endpoint/(*path)',
        via: :get,
        to: TradeTariffFrontend::RequestForwarder.new(
          host: Rails.application.config.api_host,
          api_request_path_formatter: ->(path) {
            path.gsub("v1/", "")
          }
        )
    end
  end

  root to: redirect("https://www.gov.uk/trade-tariff", status: 302)

  get "/robots.:format", to: "pages#robots"
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  match "/503", to: "errors#maintenance", via: :all
end
