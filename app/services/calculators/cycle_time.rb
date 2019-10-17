module Calculators
  class CycleTime
    attr_accessor :lists
    def initialize(board)
      @board = board
      @configs = BoardConfiguration.config_by_board_type(board.id, 'cycle_time_lists')
      self.lists = []
      @configs.each do |config|
        self.lists.push(TrelloList.find_by_trello_id(config.value).name)
      end
    end

    def historical_cycle_time(history)
      cycle_time = {}
      history.each do |date, data|
        cycle_time[date] = 0
        self.lists.each do |list|
          cycle_time[date] += data[list] ? data[list]['average'] : 0
        end
      end
      return cycle_time
    end
  end
end
