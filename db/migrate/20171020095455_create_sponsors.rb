class CreateSponsors < ActiveRecord::Migration[5.1]
  def change
    create_table :sponsors do |t|
      t.string :name
      t.string :sponsor_url_image

      t.timestamps
    end
  end
end
