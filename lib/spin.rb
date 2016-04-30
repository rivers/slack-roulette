class Spin
  attr_reader :team_id, :group_name

  def initialize(team_id:, group_name:)
    @team_id    = team_id
    @group_name = group_name.gsub(/\A@/, '')
  end

  def response
    return missing_team_response  unless team
    return missing_name_response  unless group_name.size > 0
    return missing_group_response unless usergroup

    success_response
  end

  private

  def missing_team_response
    {
      text: 'Sorry, you must authorize this application at ' \
            "#{ENV['BASE_URL']} before you can use this command."
    }
  end

  def missing_name_response
    { text: available_groups_text }
  end

  def missing_group_response
    { text: missing_group_response_text }
  end

  def missing_group_response_text
    [
      "Can't find a group named '#{group_name}'.",
      available_groups_text
    ].join("\n")
  end

  def success_response
    {
      response_type: 'in_channel',
      text: "Roulette for `#{group_name}` chose ... <@#{chosen_id}>!",
      attachments: [
        {
          author_name: chosen_name,
          author_icon: chosen_icon
        }
      ]
    }
  end

  def available_groups_text
    "Available groups: #{all_group_names.join(', ')}"
  end

  def all_group_names
    team.usergroups.map do |group|
      "#{group.fetch('handle')} (#{group.fetch('user_count')})"
    end
  end

  # @return [Team]
  #
  def team
    @team ||= Team.find_by(team_id: team_id)
  end

  # @return [Hash]
  #
  def chosen
    return @chosen if defined?(@chosen)

    @chosen = choose
  end

  # @return [Hash]
  #
  def usergroup
    return @usergroup if defined?(@usergroup)

    @usergroup = team.usergroups.detect do |group|
      group.fetch('handle') == group_name
    end
  end

  # @return [Hash]
  #
  def choose
    team.user_info(usergroup.fetch('users').sample).fetch('user')
  end

  def chosen_id
    chosen.fetch('id')
  end

  def chosen_name
    chosen.fetch('real_name')
  end

  def chosen_icon
    chosen.fetch('profile').fetch('image_24')
  end
end
