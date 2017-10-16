class CreateCharityFeaturedMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :charity_featured_members do |t|
      t.references :charity, index: true, foreigner_key: true
      t.references :member, index: true, foreigner_key: true
      t.integer :position

      t.timestamps
    end
  end
end
