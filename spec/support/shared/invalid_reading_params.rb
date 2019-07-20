shared_examples_for 'InvalidReadingParams' do

  it 'returns failure' do
    expect(operation.failure?).to be_truthy
  end

  it "doesn't cache a reading attributes" do
    operation
    expect(Rails.cache.fetch(thermostat.household_token)).to be_nil
  end

  it 'adds an error message to operation errors' do
    expect(operation[:errors]).to eq(error_context)
  end

  it "doesn't add a new reading in the database" do
    expect {operation}.to_not change(Reading, :count)
  end
end