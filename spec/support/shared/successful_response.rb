shared_examples_for 'SuccessfulResponse' do
  it 'returns status :ok' do
    expect(response).to be_successful
  end
end