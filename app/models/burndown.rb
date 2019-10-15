class Burndown < ApplicationRecord
  belongs_to :trello_board
  has_many :burndown_configs

  def config_hash
    configs = {}
    burndown_configs.each do |config|
      configs[config.config_type].nil? ? configs[config.config_type] = [config.value] : configs[config.config_type].push(config.value)
    end
    return configs
  end
end
