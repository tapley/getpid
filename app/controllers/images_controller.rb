class ImagesController < ApplicationController

  def show
    patient = Patient.find_by_image(secure_params.image)
    if patient
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
