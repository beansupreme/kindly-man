class Fact < ActiveRecord::Base
  validates :subject, :title, presence: true
end
