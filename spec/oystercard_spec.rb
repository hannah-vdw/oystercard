require 'oystercard'

describe Oystercard do  

  subject(:oystercard) { described_class.new }
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station}
  let(:journey) { {entry_station: entry_station, exit_station: exit_station} }

  it 'checks if no money on card' do
    expect(oystercard.balance).to eq(0)
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }
    it 'can top up the balance' do
      expect{ oystercard.top_up 10 }.to change{ oystercard.balance }.by 10
    end
    it 'doesn\'t allow excession of £90' do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      oystercard.top_up(maximum_balance)
      expect{ oystercard.top_up(10) }.to raise_error "£#{maximum_balance} limit"
    end
  end

  # describe '#deduct' do
  #   it { is_expected.to respond_to(:deduct).with(1).argument }
  # end
  # it 'can deduct the balance' do
  #   expect{ oystercard.deduct 1 }.to change{ oystercard.balance }.by -1
  # end

  describe '#touch_in' do

    it { is_expected.to respond_to(:touch_in)}

    it 'doesn\'t allow travel if balance lower than £1' do
      expect{ oystercard.touch_in(entry_station)}.to raise_error "Insufficient funds. Please top up"
    end

    it 'remembers the entry station' do
      oystercard.top_up(5)
      oystercard.touch_in(entry_station)
      expect(oystercard.entry_station).to eq entry_station
      # expect(oystercard.touch_in(entry_station)).to be_in_journey
    end

  end

  describe '#touch_out' do
    it { is_expected.to respond_to(:touch_out)}

    it 'deducts fare' do
      minimum_fare = Oystercard::MINIMUM_FARE
      oystercard.top_up(5)
      oystercard.touch_in(entry_station)
      expect { oystercard.touch_out(exit_station) }.to change{ oystercard.balance }.by(-minimum_fare)
    end

    it 'forgets the entry station' do
      oystercard.top_up(5)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.entry_station).to eq nil
    end

  end
  
  describe '#in_journey?' do
    it { is_expected.to respond_to(:in_journey?)}
    it 'is initially not in a journey' do
      expect(oystercard).not_to be_in_journey
    end
    it 'it can touch in' do
      oystercard.top_up(1)
      oystercard.touch_in(entry_station)
      expect(oystercard).to be_in_journey
    end
    it "can touch out" do
      oystercard.top_up(1)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard).not_to be_in_journey
    end

    it "returns and empty list" do
      expect(oystercard.journeys).to be_empty
    end

    it "can store a journey" do
      oystercard.top_up(5)
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.journeys).to include journey
    end

  end
end 
