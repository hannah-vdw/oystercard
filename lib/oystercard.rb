class Oystercard
  MAXIMUM_BALANCE = 90
  attr_reader :balance
  attr_reader :status
  def initialize
    @balance = 0
    @status = nil
  end

  def top_up(sum)
    fail "£#{MAXIMUM_BALANCE} limit" if (@balance + sum) > MAXIMUM_BALANCE
    @balance += sum
  end
  def deduct(fare)
    @balance -= fare
  end
  def touch_in
    @status = true
  end
  def touch_out
    @status = false 
  end
  def in_journey?
    @status == true ? true : false
  end
end