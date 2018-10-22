require 'rails_helper'

RSpec.describe Item, type: :model do
  # Association test
  # Ensure an Item record belongs to a single Checklist record
  it { should belong_to(:checklist) }

  # Validation test
  # Ensure column "name" is present before saving
  it { should validate_presence_of(:name) }
end
