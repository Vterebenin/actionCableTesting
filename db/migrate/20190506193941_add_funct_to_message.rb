class AddFunctToMessage < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :funct, :string
  end
end
