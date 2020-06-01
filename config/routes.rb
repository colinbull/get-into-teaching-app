Rails.application.routes.draw do
  root to: "pages#home"

  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all
  get "/events", to: "pages#events", via: :all, as: nil
  get "/eventschool", to: "pages#eventschool", via: :all
  get "/event", to: "pages#event", via: :all, as: nil
  get "/event/register/:step_number", to: "pages#eventregistration", via: :all

  get "/apievents", to: "events#index", as: :events
  get "/apievents/search", to: "events#search", as: :search_events

  if Rails.env.development?
    get "/apistubs/*stub", to: "apistubs#show"
  end

  get "*page", to: "pages#show", as: :page
end
