class Question < ActiveRecord::Base
  validates_presence_of :type, :text, :ftype
end

class ImportanceQuestion < Question
end

class BooleanQuestion < Question
end
