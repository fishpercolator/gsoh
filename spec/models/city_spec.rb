require 'rails_helper'

RSpec.describe City, type: :model do
  
  subject { described_class.new(name: 'leeds') }
  
  describe '#metadata' do
    it 'loads the global metadata' do
      expect(subject.send(:metadata)).to have_key('osm')
      expect(subject.send(:metadata)['osm']).to have_key('bank')
    end
    it 'loads the city metadata' do
      expect(subject.send(:metadata)).to have_key('bounds')
      expect(subject.send(:metadata)).to have_key('ckan')
    end
  end
  
  describe '#osm_to_feature' do
    let(:osm) { {tags: tags, lat: 53.814, lon: -1.547} }
    let(:generated) { subject.send(:osm_to_feature, ftype, osm) }

    context 'place_of_worship' do
      let(:ftype) { 'place_of_worship' }
      let(:tags) { {name: 'Some name', amenity: 'place_of_worship', religion: 'christian'} }
      
      it 'generates a Feature' do
        expect(generated).to be_a(Feature)
      end
      it 'sets the ftype' do
        expect(generated.ftype).to eq('place_of_worship')
      end
      it 'sets lat/lng' do
        expect(generated.lat).to eq(53.814)
        expect(generated.lng).to eq(-1.547)
      end
      it 'sets the name' do
        expect(generated.name).to eq('Some name')
      end
      it 'sets the subtype' do
        expect(generated.subtype).to eq('christian')
      end
    end
    context 'sports_centre' do
      let(:ftype) { 'sports_centre' }
      let(:tags) { {name: 'Some name', leisure: 'sports_centre'} }
      it 'sets the ftype' do
        expect(generated.ftype).to eq('sports_centre')
      end
      it 'does not set the subtype' do
        expect(generated.subtype).to be nil
      end
    end
    context 'bus_stop' do
      let(:ftype) { 'bus_stop' }
      context 'with shelter' do
        let(:tags) { {name: 'Some name', highway: 'bus_stop', shelter: 'yes'} }
        it 'sets the ftype' do
          expect(generated.ftype).to eq('bus_stop')
        end
        it 'sets the subtype' do
          expect(generated.subtype).to eq('with_shelter')
        end
      end
      context 'without shelter' do
        let(:tags) { {name: 'Some name', highway: 'bus_stop', shelter: 'no'} }
        it 'sets the ftype' do
          expect(generated.ftype).to eq('bus_stop')
        end
        it 'does not set the subtype' do
          expect(generated.subtype).to be nil
        end
      end
    end
  end
  
  describe '#ckan_row_to_feature' do
    let(:cols) { subject.send(:metadata)['ckan'].values.first[ftype]['columns'] }
    let(:generated) { subject.send(:ckan_row_to_feature, ftype, row, cols) }
    
    context 'nns' do
      let(:ftype) { 'nns' }
      let(:row) { {'nameOfNeighbourhoodNetworkScheme' => 'AGE', 'Easting' => '433437', 'Northing' => '435529'} }
      it 'generates a Feature' do
        expect(generated).to be_a(Feature)
      end
      it 'sets the name' do
        expect(generated.name).to eq('AGE')
      end
      it 'sets the ftype' do
        expect(generated.ftype).to eq('nns')
      end
      it 'sets the lat/lng' do
        expect(generated.lat).to be_within(0.001).of(53.815)
        expect(generated.lng).to be_within(0.001).of(-1.493)
      end
    end
    
    context 'public_wifi' do
      let(:ftype) { 'public_wifi' }
      let(:row) { {'Site name' => '2 Great George Street', 'Latitude' => '53.80116', 'Longitude' => '-1.54549'} }
      it 'generates a Feature' do
        expect(generated).to be_a(Feature)
      end
      it 'sets the name' do
        expect(generated.name).to eq('2 Great George Street')
      end
      it 'sets the ftype' do
        expect(generated.ftype).to eq('public_wifi')
      end
      it 'sets the lat/lng' do
        expect(generated.lat).to be_within(0.001).of(53.801)
        expect(generated.lng).to be_within(0.001).of(-1.545)
      end
    end
  end
  
end
