class CreateSponsors < ActiveRecord::Migration[5.1]
  def change
    create_table :sponsors do |t|
      t.string :name
      t.references :member, index: true, foreigner_key: true
      t.references :charity, index: true, foreigner_key: true
      t.string :sponsor_url_image

      t.timestamps
    end
  end
end
