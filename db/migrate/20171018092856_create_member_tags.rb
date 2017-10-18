class CreateMemberTags < ActiveRecord::Migration[5.1]
  def change
    create_table :member_tags do |t|
      t.references :member, index: true, foreigner_key: true
      t.string :tag

      t.timestamps
    end
  end
end
