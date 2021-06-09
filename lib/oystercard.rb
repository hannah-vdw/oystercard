class Oystercard

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 2.4

  attr_reader :balance, :status

  def initialize
    @balance = 0
    @status = nil
  end

  def top_up(sum)
    fail "£#{MAXIMUM_BALANCE} limit" if (@balance + sum) > MAXIMUM_BALANCE
    @balance += sum
  end

  def touch_in
    fail "Insufficient funds. Please top up" if @balance < MINIMUM_BALANCE
    @status = true
  end

  def touch_out
    @status = false 
    deduct(MINIMUM_FARE)
  end
  
  def in_journey?
    @status == true ? true : false
  end

  private

  def deduct(fare)
    @balance -= fare
  end

end