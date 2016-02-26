require 'rails_helper'

RSpec.describe Area, type: :model do
  
  subject do
    create :area, geography: {n: 53.8177, w: -1.5252, s: 53.8057, e: -1.5051}
  end
  
  describe '#features' do
    let!(:feature_inside_area) { create :feature, lat: 53.8090, lng: -1.5103 }
    let!(:feature_outside_lat) { create :feature, lat: 53.9922, lng: -1.5103 }
    let!(:feature_outside_lng) { create :feature, lat: 53.8090, lng: -1.5010 }
    
    it 'finds features inside the area' do
      expect(subject.features).to include(feature_inside_area)
    end
    
    it 'does not find features outside the area' do
      expect(subject.features).not_to include(feature_outside_lat)
      expect(subject.features).not_to include(feature_outside_lng)
    end
  end
end
