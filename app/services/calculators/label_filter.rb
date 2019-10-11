module Calculators
  class LabelFilter
    def initialize(board)
      filter_config = BoardConfiguration.config_by_board_type(board.id, 'filtered_labels')
      @filter = []
      filter_config.each do |label|
        @filter.push(label.value)
      end
      @filtered = build_filter(board)
    end

    def is_filtered?(card)
      return is_filtered_by_id?(card.id)
    end

    def is_filtered_by_id?(trello_card_id)
      return !@filtered[trello_card_id].nil?
    end

    def filter_cards(cards)
      f_cards = []
      cards.each do |card|
        f_cards.push(card) unless is_filtered?(card)
      end
      return f_cards
    end

    def check_card_labels(card)
      card.trello_labels.each do |label|
        if @filter.select {|l| label.trello_id.match?(/#{l}/)}.count > 0
          return true
        end
      end
      return false
    end

    private

    def build_filter(board)
      filtered_cards = {}
      return filtered_cards if @filter.count == 0
      board.trello_cards.each do |card|
        filtered_cards[card.id] = card if check_card_labels(card)
      end
      return filtered_cards
    end

  end
end
