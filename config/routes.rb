Rails.application.routes.draw do

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
  get 'axolotl_stats/index'

  get 'axolotl_stats/show'

  get 'toy/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
