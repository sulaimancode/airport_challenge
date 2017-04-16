require 'airport'

describe Airport do
  let(:weather) { double :weather }
  let(:plane) { double :plane }
  subject { described_class.new(weather) }

  describe 'initializtion' do
    it { is_expected.to respond_to :planes }

    it 'should have a place to store planes' do
      expect(subject.planes).to eq []
    end
  end

  it 'should prevent landing when weather is stormy' do
    allow(weather).to receive(:condition) { 'stormy' }
    expect { subject.land(plane) }.to raise_error 'can not land, weather condition stormy'
  end

  describe '#land' do
    before do
      allow(weather).to receive(:condition) { 'sunny' }
    end
    it { is_expected.to respond_to(:land).with(1).argument }

    it 'it should land a plane' do
      subject.land(plane)
    end

    it 'should confirm plane has landed' do
      subject.land(plane)
      expect(subject.planes).to include plane
    end

    it 'should not let planes that are landed to land again' do
      subject.land(plane)
      expect { subject.land(plane) }.to raise_error 'plane already landed'
    end
  end

  describe '#take_off' do
    it { is_expected.to respond_to(:take_off).with(1).argument }
    it 'should let a plane take off' do
      allow(weather).to receive(:condition) { 'sunny' }

      subject.land(plane)
      subject.take_off(plane)
    end

    it 'should confirm plane has taken off' do
      allow(weather).to receive(:condition) { 'sunny' }
      subject.land(plane)
      subject.take_off(plane)
      expect(subject.planes).to_not include plane
    end

    it 'should prevent take off when weather is stormy' do
      allow(weather).to receive(:condition) { 'sunny' }
      subject.land(plane)
      allow(weather).to receive(:condition) { 'stormy' }
      expect { subject.take_off(plane) }.to raise_error 'can not take off, weather condition stormy'
    end
  end
end