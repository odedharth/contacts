class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.integer :mobile
      t.integer :voip

      t.timestamps
    end
  end
end
