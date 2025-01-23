class AddSyllableCountTags < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        ['字足らず', '字余り'].each do |name|
          Tag.create!(name: name)
        end
      end

      dir.down do
        Tag.where(name: ['字足らず', '字余り']).destroy_all
      end
    end
  end
end
