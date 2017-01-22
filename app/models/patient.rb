class Patient < ApplicationRecord

  def self.upload_image(args)
    rekognition = self.new_rekognition_client
    file = File.open(args[:image], "rb")
    response = rekognition.index_faces({
      collection_id: ENV['AWS_COLLECTION_ID'], # required
      image: { bytes: file.read }
    })

    raise "Multiple faces detected." if response.face_records.length > 1
    raise "Face detection failed." if response.face_records.length < 1

    Patient.create(name: args[:name], birth_date: args[:birth_date], aws_patient_id: response.face_records.first.face.face_id)
  end

  def self.find_by_image(image)
    return if !image

    rekognition = self.new_rekognition_client
    response = rekognition.search_faces_by_image({
      collection_id: ENV['AWS_COLLECTION_ID'], # required
      image: { bytes: image },
      max_faces: 1,
      face_match_threshold: 0.99,
    })
    
    pp response

    (response.face_matches.length == 1) ? Patient.where(aws_patient_id: response.face_matches.first.face.face_id).first : nil
  end


  def self.new_rekognition_client
    Aws::Rekognition::Client.new(access_key_id: ENV['AWS_ACCESS_KEY'],secret_access_key: ENV['AWS_SECRET_KEY'], region: ENV['AWS_REGION'])
  end
end
