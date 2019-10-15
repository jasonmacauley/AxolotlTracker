Rails.application.routes.draw do

  get 'burndown/index/:board_id' => 'burndown#index', as: :burndowns

  get 'burndown/show/:id' => 'burndown#show', as: :burndown

  post 'burndown/create/:board_id' => 'burndown#create', as: :create_burndown

  get '/burndown/new/:board_id' => 'burndown#new', as: :new_burndown

  post 'burndown/update/:id' => 'burndown#update', as: :update_burndown

  get 'burndown/edit/:id' => 'burndown#edit', as: :edit_burndown
  delete 'burndown/:id' => 'burndown#destroy', as: :delete_burndown

  resource :trello_credentials
  get '/events/new/:trello_board_id' => 'events#new', as: :new_event
  post '/events/create/:trello_board_id' => 'events#create', as: :create_event
  get '/events/index/:trello_board_id' => 'events#index', as: :view_board_events
  get '/events/show/:trello_board_id/:start_date' => 'events#show', as: :view_events
  get '/events/edit/:id' => 'events#edit', as: :edit_event
  post '/events/update/:id' => 'events#update', as: :update_event
  delete '/events/:trello_board_id/:id' => 'events#destroy', as: :delete_event
  #resource :events

  devise_for :users
  root 'trello_boards#index'

  get 'board_configuration/new'

  get '/activate/:trello_id' => 'board_configuration#new', as: :activate_board

  get 'board_configuration/show'

  get 'board_configuration/index'

  get 'board_configuration/edit'

  post 'board_configuration/update'

  get '/trello_boards' => 'trello_boards#index', as: :trello_boards
  get '/trello_boards/:id' => 'trello_boards#show', as: :trello_board
  get '/cards/:board_id/:start_date/:card_type' => 'cards#show', as: :cards_by_type
  get '/cards/:board_id/:start_date' => 'cards#show', as: :cards

  get '/refresh/:id' => 'refresh#refresh', as: :refresh
  get '/refresh' => 'refresh#refresh_all', as: :refresh_all

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
