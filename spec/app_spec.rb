describe 'application' do
  it 'renders index' do
    get '/'

    expect(last_response).to be_ok
  end

  it 'rejects spin with invalid token' do
    post '/spin'

    expect(last_response.status).to eq(401)
    expect(last_response.body).to eq('')
  end

  it 'accepts spin with valid token' do
    allow_any_instance_of(Spin).to receive(:response).and_return(foo: 'bar')

    post '/spin',
      token:   ENV['SPIN_TOKEN'],
      team_id: 'team_id',
      text:    'group_name'

    expect(last_response).to be_ok
    parsed = JSON.parse(last_response.body)
    expect(parsed).to eq('foo' => 'bar')
  end
end
