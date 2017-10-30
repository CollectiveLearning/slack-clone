class ChangeTypeColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :messages, :type, :kind
  end
end
