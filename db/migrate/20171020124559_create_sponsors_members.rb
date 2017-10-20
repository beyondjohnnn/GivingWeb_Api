class CreateSponsorsMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :sponsors_members do |t|
      t.references :sponsor, index: true, foreigner_key: true
      t.references :member, index: true, foreigner_key: true

      t.timestamps
    end
  end
end
