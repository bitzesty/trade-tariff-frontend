require 'trade_tariff_frontend'

Rails.application.routes.draw do
  get "/trade-tariff/*path", to: redirect('/%{path}', status: 301)
  get "/api/(*path)", constraints: { path: /[^v\d+].*/ }, to: redirect { |_params, request| request.url.gsub('/api/', "/api/v2/") }
  get "/v1/(*path)", to: redirect { |_params, request| "/api#{request.path}?#{request.query_string}" }
  get "/v2/(*path)", to: redirect { |_params, request| "/api#{request.path}?#{request.query_string}" }
  get "/api/:version/commodities/:id", to: redirect { |_params, request| request.url.gsub('commodities', 'chapters').gsub('00000000', '') }, constraints: { id: /\d{2}00000000/ }
  get "/api/:version/commodities/:id", to: redirect { |_params, request| request.url.gsub('commodities', 'headings').gsub('000000', '') }, constraints: { id: /\d{4}000000/ }
  get "/api/v1/quotas/search", to: redirect('/api/v2/quotas/search', status: 301)

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

  match "/search", to: "search#search", as: :perform_search, via: %i[get post]
  get "search_suggestions", to: "search#suggestions", as: :search_suggestions
  get 'quota_search', to: 'search#quota_search', as: :quota_search
  get 'additional_code_search', to: 'search#additional_code_search', as: :additional_code_search
  get 'certificate_search', to: 'search#certificate_search', as: :certificate_search
  get 'footnote_search', to: 'search#footnote_search', as: :footnote_search
  match "a-z-index/:letter",
        to: "search_references#show",
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
            api_request_path_formatter: lambda { |path|
              path.gsub("#{APP_SLUG}/", "")
            }
          )
  end

  constraints(id: /[\d]{1,2}/) do
    resources :sections, only: %i[index show]
  end

  constraints(id: /[\d]{2}/) do
    resources :chapters, only: %i[index show] do
      resources :changes,
                only: [:index],
                defaults: { format: :atom },
                module: 'chapters'
    end
  end

  constraints(id: /[\d]{4}/) do
    resources :headings, only: %i[index show] do
      resources :changes,
                only: [:index],
                defaults: { format: :atom },
                module: 'headings'
    end
  end

  constraints(id: /[\d]{10}/) do
    resources :commodities, only: %i[index show] do
      resources :changes,
                only: [:index],
                defaults: { format: :atom },
                module: 'commodities'
    end
  end

  constraints(TradeTariffFrontend::ApiPubConstraints.new(TradeTariffFrontend.public_api_endpoints)) do
    scope 'api' do
      get ":version/*path", to: TradeTariffFrontend::RequestForwarder.new(
        host: Rails.application.config.api_host,
        api_request_path_formatter: lambda { |path|
          path.gsub(/api\/v\d+\//, '')
        }
      ), constraints: { version: /v[1-2]{1}/ }

      get "v2/goods_nomenclatures/*path", to: TradeTariffFrontend::RequestForwarder.new(
        host: Rails.application.config.api_host,
        api_request_path_formatter: lambda { |path|
          path.gsub(/api\/v2\//, '')
        }
      )
    end
  end

  root to: redirect("https://www.gov.uk/trade-tariff", status: 302)

  get "/robots.:format", to: "pages#robots"
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  match "/503", to: "errors#maintenance", via: :all
  match "*path", to: "errors#not_found", via: :all
end
