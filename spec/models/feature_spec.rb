require 'rails_helper'

RSpec.describe Feature, type: :model do
  
  describe '.from_osm' do
    subject { described_class.from_osm(osm) }
    
    context 'node type' do
      context '(pharmacy)' do
        let(:osm) {{
          type: 'node',
          tags: {amenity: 'pharmacy', name: 'Boots'},
          lat: 53.814,
          lon: -1.547
        }}
        it 'constructs a valid model' do
          expect(subject).to be_a(described_class)
        end
        it 'sets ftype' do
          expect(subject.ftype).to eq('pharmacy')
        end
        it 'does not set subtype' do
          expect(subject.subtype).to be_nil
        end
        it 'sets name' do
          expect(subject.name).to eq('Boots')
        end
        it 'sets lat/lng' do
          expect(subject.lat).to be_within(0.001).of(53.814)
          expect(subject.lng).to be_within(0.001).of(-1.547)
        end
        context '(place of worship)' do
          let(:osm) {{
            type: 'node',
            tags: {amenity: 'place_of_worship', religion: 'christian'}
          }}
          it 'sets ftype' do
            expect(subject.ftype).to eq('place_of_worship')
          end
          it 'sets subtype' do
            expect(subject.subtype).to eq('christian')
          end
        end
      end
    end
    
    context 'way type' do
      let(:osm) {{
        type: 'way',
        tags: {amenity: 'pharmacy', name: 'Boots'},
        nodes: [
          {type: 'node', lat: 53.814, lon: -1.547},
          {type: 'node', lat: 53.900, lon: -1.433}
        ]
      }}
      it 'sets ftype' do
        expect(subject.ftype).to eq('pharmacy')
      end
      it 'sets name' do
        expect(subject.name).to eq('Boots')
      end
      it 'sets lat/lng' do
        expect(subject.lat).to be_within(0.001).of(53.814)
        expect(subject.lng).to be_within(0.001).of(-1.547)
      end
    end
  end
  
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
  
  describe '.subtypes_for' do
    it 'finds only the relevant subtypes in alphabetical order' do
      %w{one two three four}.each {|s| create :feature, ftype: 'wibble', subtype: s}
      %w{five six seven}.each     {|s| create :feature, ftype: 'wobble', subtype: s}
      expect(described_class.subtypes_for('wibble')).to eq(%w{four one three two})
    end
  end
  
end
