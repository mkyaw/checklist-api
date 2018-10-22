require 'rails_helper'

RSpec.describe Checklist, type: :model do
  # Association Test
  # Ensure Checklist model has 1:m association with Item model
  it { should have_many(:items).dependent(:destroy) }

  # Validation tests
  # Ensure columns "title" and "created_by" are present before saving
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:created_by) }
end
