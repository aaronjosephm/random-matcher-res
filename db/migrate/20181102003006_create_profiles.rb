class CreateProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.integer :age
      t.string :ethnicity
      t.string :height
      t.string :body_type
      t.string :url
      t.string :picture
      t.string :name
      t.string :interests
      t.integer :points

      t.timestamps
    end
  end
end
