require 'json'

get '/' do
  erb :index
end

get Client.callback_path do
  token = Client.get_access_token(params.fetch('code'))

  team = Team.find_or_initialize_by(team_id: token.fetch('team_id'))

  team.assign_attributes(
    token: token.fetch('access_token'),
    scope: token.fetch('scope'),
    name:  token.fetch('team_name'))

  team.save!

  query_params = {
    authorized: 1,
    team:       CGI.escape(team.name)
  }

  redirect "/?#{query_params.to_query}"
end

post '/spin' do
  content_type 'application/json'

  begin
    return halt(401) unless params['token'] == ENV['SPIN_TOKEN']

    spin = Spin.new(
      team_id:    params.fetch('team_id'),
      group_name: params.fetch('text'))

    spin.response.to_json
  rescue
    { text: 'Sorry, something went wrong.' }.to_json
  end
end
