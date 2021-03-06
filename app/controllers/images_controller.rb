class ImagesController < ApplicationController

  def show
    50.times {puts "*"}
    pp secure_params
    Patient.where(last_seen: true).first.update(last_seen:false)
    patient = Patient.find_by_image(secure_params[:image])
    if patient
      patient.update(last_seen: true)
      render :json => { patient: patient }
    else
      render :json => { :errors => "Patient not found.", :status => 404 }
    end
  end

  private

    def secure_params
      params.require(:patient).permit(:image, :name, :birth_date)
    end
end
