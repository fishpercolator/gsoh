require 'rails_helper'

RSpec.describe Feature, type: :model do

  describe '.from_nns_data' do
    let(:nns_data) { {nameofneighbourhoodnetworkscheme: 'OWLS', easting: 427845, northing: 436087} }
    subject { described_class.from_nns_data(nns_data) }
    it 'creates a Feature' do
      expect(subject).to be_a(Feature)
    end
    it 'sets the name' do
      expect(subject.name).to eq('OWLS')
    end
    it 'sets the ftype' do
      expect(subject.ftype).to eq('nns')
    end
    it 'sets the lat/lng' do
      expect(subject.lat).to be_within(0.001).of(53.820)
      expect(subject.lng).to be_within(0.001).of(-1.578)
    end
  end
  
  describe '.from_changing_place_data' do
    let(:cp_data) { {location: 'Central Library', easting: 429859, northing: 433879} }
    subject { described_class.from_changing_place_data(cp_data) }
    it 'creates a Feature' do
      expect(subject).to be_a(Feature)
    end
    it 'sets the name' do
      expect(subject.name).to eq('Central Library')
    end
    it 'sets the ftype' do
      expect(subject.ftype).to eq('changing_place')
    end
    it 'sets the lat/lng' do
      expect(subject.lat).to be_within(0.001).of(53.800)
      expect(subject.lng).to be_within(0.001).of(-1.548)
    end
  end
  
  describe '.subtypes_for' do
    it 'finds only the relevant subtypes in alphabetical order' do
      %w{one two three four}.each {|s| create :feature, ftype: 'wibble', subtype: s}
      %w{five six seven}.each     {|s| create :feature, ftype: 'wobble', subtype: s}
      expect(described_class.subtypes_for('wibble')).to eq(%w{four one three two})
    end
  end
  
end
