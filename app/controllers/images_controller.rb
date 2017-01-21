class ImagesController < ApplicationController

  def create
    response = rekognition.index_faces({
      collection_id: ENV['AWS_COLLECTION_ID'], # required
      image: { bytes: secure_params.image },
      external_image_id: "ExternalImageId",
      detection_attributes: ["DEFAULT"], # accepts DEFAULT, ALL
    })

    raise "Multiple faces detected." if response.face_records.length > 1
    raise "Face detection failed." if response.face_records.length < 1

    Patient.create(name: params[:name], birth_date: params[:birth_date], aws_patient_id: response.face_records.first.face.face_id)
  end

  def show

    response = rekognition.search_faces_by_image({
      collection_id: ENV['AWS_COLLECTION_ID'], # required
      image: { bytes: secure_params.image },
      max_faces: 1,
      face_match_threshold: 0.95,
    })

    render Patient.where(aws_patient_id: response.face_matches.first.face.face_id).first, format: :json
  end

  private

    def rekognition
      @rekognition = @rekognition || Aws::Rekognition::Client.new(access_key_id: ENV['AWS_ACCESS_KEY'],secret_access_key: ENV['AWS_SECRET_KEY'])
      @rekognition
    end

    def secure_params
      params.require(:patient).permit(:image, :name, :birth_date)
    end
end
