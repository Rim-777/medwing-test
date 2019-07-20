shared_examples_for 'Cacheble' do
  it 'tries to takes data from cache' do
    expect(Rails.cache).to receive(:fetch).once.with(thermostat.household_token)
    expect(Reading).to_not receive(:find_by_tracking_number)
    operation
  end
end