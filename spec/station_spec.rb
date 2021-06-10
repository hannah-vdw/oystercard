require 'station'

describe Station do

  subject {described_class.new(name: "Waterloo", zone: 1)}
  
  it "initializes with a name" do
    # subject(:station) { described_class.new(name: "Waterloo", zone: 1) }
    # station = Station.new("Waterloo", 1)

    expect(subject.name).to eq("Waterloo")
  end

  it "initializes with a zone" do
    expect(subject.zone).to eq(1)
  end

end
