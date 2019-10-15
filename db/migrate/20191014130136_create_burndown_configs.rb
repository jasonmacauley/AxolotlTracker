class CreateBurndownConfigs < ActiveRecord::Migration[5.1]
  def change
    create_table :burndown_configs do |t|
      t.string :config_type
      t.string :value

      t.timestamps
    end
  end
end
