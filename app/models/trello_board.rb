class TrelloBoard < ApplicationRecord
  has_many :trello_cards
  has_many :board_configurations
  has_many :trello_lists
  has_many :events
  has_many :trello_labels
  has_many :burndowns

  def config_hash
    return @config_hash unless @config_hash.nil?

    @config_hash = {}
    self.board_configurations.each do |config|
      @config_hash[config.config_type].nil? ?
          @config_hash[config.config_type] = [config.value] :
          @config_hash[config.config_type].push(config.value)
    end
    return @config_hash
  end
end
