class HomeController < ApplicationController

  def show
    @patient = Patient.where(last_seen: true).first
    render :show
  end
end
