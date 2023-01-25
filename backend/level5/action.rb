class Action
  attr_reader :who, :type, :amount

  def initialize(params = {})
    @who = params[:who]
    @type = params[:type]
    @amount = params[:amount]
  end

  # output method format the desired output to be converted in json
  def output
    {
      "who": @who,
      "type": @type,
      "amount": @amount
    }
  end
end
