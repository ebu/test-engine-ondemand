class CreateRemoteJobs < ActiveRecord::Migration
  def change
    create_table :remote_jobs do |t|
      t.string  :remote_id
      t.text    :stderr
      t.text    :stdout
      t.integer :code
      t.string  :command
      t.text    :arguments
      t.timestamps
    end
  end
end
