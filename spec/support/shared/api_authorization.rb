shared_examples_for 'API Authorizable' do
  context 'Unauthorizes' do
    it 'returns 401 if no access token provided' do
      do_request(method, api_path, params: request_params ||= nil, headers: headers)
      expect(response.status).to eq 401
    end

    it 'returns 401 if access token is invalid' do
      do_request(method, api_path, params: { access_token: '123' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'Public Fields Returnable' do
  it 'returns all public fields' do
    public_fields.each do |public_field|
      expect(resource_response[public_field]).to eq resource.send(public_field).as_json
    end
  end
end

shared_examples_for 'Private Fields Non-Returnable' do
  it 'does not return private fields' do
    private_fields.each do |private_field|
      expect(resource_response).to_not have_key(private_field)
    end
  end
end

shared_examples_for 'Resource Unauthorizable' do
  it 'returns fail status' do
    expect(response).to_not be_successful
  end
end
