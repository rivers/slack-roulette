class Team < ActiveRecord::Base
  # @return [Hash]
  #
  def user_info(user_id)
    Client.get('users.info', token: token, user: user_id)
  end

  # @return [Array<Hash>]
  #
  def usergroups
    return @usergroups if defined?(@usergroups)

    params = {
      token:            token,
      include_disabled: 0,
      include_users:    1
    }

    @usergroups = Client.get('usergroups.list', params).fetch('usergroups')
  end
end
