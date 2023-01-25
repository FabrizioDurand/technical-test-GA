require './json_methods'

class Commission
  attr_reader :insurance_fee, :assistance_fee, :drivy_fee

  def initialize(params = {})
    @insurance_fee = params[:insurance_fee]
    @assistance_fee = params[:assistance_fee]
    @drivy_fee = params[:drivy_fee]
  end
end
