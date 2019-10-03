class ChangeBoardIdToTrelloBoardIdOnBoardConfiguration < ActiveRecord::Migration[5.1]
  def change
    rename_column :board_configurations, :board_id, :trello_board_id
  end
end
