class AddLastSeenToPatient < ActiveRecord::Migration[5.0]
  def change
    add_column :patients, :last_seen, :boolean
  end
end
