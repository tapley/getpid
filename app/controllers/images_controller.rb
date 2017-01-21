class ImagesController < ApplicationController

  def show
    render Patient.find_by_image(secure_params.image), format: :json
  end

  private

    def secure_params
      params.require(:patient).permit(:image, :name, :birth_date)
    end
end
