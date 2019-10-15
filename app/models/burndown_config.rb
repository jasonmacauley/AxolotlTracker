class BurndownConfig < ApplicationRecord
  belongs_to :burndown
  scope :config_by_burndown_type, lambda {|burndown_id, config_type|
    where('burndown_id = ? AND config_type = ?',
          burndown_id, config_type)}
  scope :config_by_burndown_type_value, lambda {|burndown_id, config_type, value|
    where('burndown_id = ? AND config_type = ? AND value = ?',
          burndown_id, config_type, value)}
end
