shared_examples_for 'UnouthorizedThermostat' do
  it 'returns failure with  the unauthorized status' do
    expect(response.status).to eq 401
  end

  it 'returns an empty response body' do
    expect(response.body).to be_empty
  end
end