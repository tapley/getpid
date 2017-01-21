class CreatePatients < ActiveRecord::Migration[5.0]
  def change
    create_table :patients do |t|

      t.string      :name
      t.date        :birth_date
      t.references  :emr
      t.string      :emr_patient_id
      t.string      :aws_patient_id

      t.timestamps
    end
  end
end
