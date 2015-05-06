class CreateFacts < ActiveRecord::Migration
  def change
    create_table :facts do |t|
      t.string :title
      t.text :subject

      t.timestamps null: false
    end
  end
end
