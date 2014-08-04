class ChangeEncoderFlagsToText < ActiveRecord::Migration
  def up
    change_column :variant_jobs, :encoder_flags, :text
  end

  def down
    change_column :variant_jobs, :encoder_flags, :string
  end
end
