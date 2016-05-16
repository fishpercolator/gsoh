require 'rails_helper'

RSpec.describe Feature, type: :model do
  
  describe '.subtypes_for' do
    it 'finds only the relevant subtypes in alphabetical order' do
      %w{one two three four}.each {|s| create :feature, ftype: 'wibble', subtype: s}
      %w{five six seven}.each     {|s| create :feature, ftype: 'wobble', subtype: s}
      expect(described_class.subtypes_for('wibble')).to eq(%w{four one three two})
    end
  end
  
end
