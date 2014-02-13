class CreateAssets < ActiveRecord::Migration
  def change
    create_table :file_assets do |t|

      t.timestamps
    end
  end
end
