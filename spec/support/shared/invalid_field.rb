shared_examples_for 'InvalidField' do
  it 'returns failure with  the unprocessable entity' do
    expect(response.status).to eq 422
  end

  it 'returns response matched to the json schima' do
    expect(response).to match_response_schema(schema)
  end
end