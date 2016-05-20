require 'rails_helper'

RSpec.describe Area, type: :model do
  
  subject { create :area, :central_leeds }
  
  describe '#features' do
    let!(:inside)  { create :feature, :in_city_centre }
    let!(:outside) { create :feature, :outside_city_centre }
    
    it 'finds features inside the area' do
      expect(subject.features).to include(inside)
    end
    
    it 'does not find features outside the area' do
      expect(subject.features).not_to include(outside)
    end
  end
  
  describe '#contains?' do
    let!(:pharmacy_inside) { create :feature, :in_city_centre, ftype: 'pharmacy' }
    let!(:church_inside)   { create :feature, :also_in_city_centre, ftype: 'place_of_worship', subtype: 'christian' }
    let!(:mosque_outside)  { create :feature, :outside_city_centre, ftype: 'place_of_worship', subtype: 'muslim' }
    let!(:school_outside)  { create :feature, :outside_city_centre, ftype: 'school' }
    before(:each) do
      # To update the cache of features in the given area
      subject.save
    end
    
    it 'contains pharmacy' do
      expect(subject.contains?('pharmacy')).to be_truthy
    end
    it 'does not contain school' do
      expect(subject.contains?('school')).not_to be_truthy
    end
    it 'contains church' do
      expect(subject.contains?('place_of_worship', subtype: 'christian')).to be_truthy
    end
    it 'does not contain mosque' do
      expect(subject.contains?('place_of_worship', subtype: 'mosque')).not_to be_truthy
    end
  end
  
  describe '#specific_feature' do
    let!(:pharmacy_inside1) { create :feature, :in_city_centre, ftype: 'pharmacy' }
    let!(:pharmacy_inside2) { create :feature, :also_in_city_centre, ftype: 'pharmacy' }
    let!(:pharmacy_outside) { create :feature, :outside_city_centre, ftype: 'pharmacy' }
    let!(:school_inside)    { create :feature, :in_city_centre, ftype: 'school' }
    
    it 'returns both pharmacies inside' do
      expect(subject.specific_feature('pharmacy')).to include(pharmacy_inside1)
      expect(subject.specific_feature('pharmacy')).to include(pharmacy_inside2)
    end
    it 'does not return the pharmacy outside' do
      expect(subject.specific_feature('pharmacy')).not_to include(pharmacy_outside)
    end
    it 'does not return the school' do
      expect(subject.specific_feature('pharmacy')).not_to include(school_inside)
    end
  end
  
  describe '#closest' do
    let!(:nns) { create :feature, :outside_city_centre, ftype: 'nns' }
    let!(:further_nns) { create :feature, :further_outside_city_centre, ftype: 'nns' }
    
    it 'returns the nearest nns even though it is not inside the area' do
      expect(subject.closest('nns')).to eq(nns)
    end
  end
  
end
