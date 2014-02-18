class CreateTranscoders < ActiveRecord::Migration
  def change
    create_table :transcoders do |t|
      t.string :host_name
      t.integer :port
      t.timestamps
    end
  end
end
