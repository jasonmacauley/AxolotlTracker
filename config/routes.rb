Rails.application.routes.draw do

  get '/trello_boards' => 'trello_boards#index'
  get '/trello_boards/:id' => 'trello_boards#show', as: :trello_board
  get '/cards/:board_id/:start_date/:card_type' => 'cards#show', as: :cards_by_type
  get '/cards/:board_id/:start_date' => 'cards#show', as: :cards


  get 'axolotl_stats/index'

  get 'axolotl_stats/show'

  get 'toy/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
