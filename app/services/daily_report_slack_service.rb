class DailyReportSlackService
  def initialize channel = "#sampleapp"
    @uri = URI("https://hooks.slack.com/services/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")
    @channel = channel
  end

  def create_report
    @current_user_count   = User.all.count
    @new_user_count       = User.new_users.count
    @new_post             = Micropost.new_posts
    @new_post_count       = Micropost.new_posts.count
    @new_comment          = Comment.new_comment
    @new_votes            = ActsAsVotable::Vote.where(created_at: (Time.now - 1.day)..Time.now)
    @interactive_user  = @new_post.pluck(:user_id) + @new_votes.pluck(:voter_id) + @new_comment.pluck(:user_id)
    @interactive_user  = @interactive_user.uniq.count
    daily_report(@current_user_count, @new_user_count, @new_post_count, @interactive_user).deliver
  end

  def daily_report user_count, new_user_count, new_post_count, interactive_user
    params = {
      attachments: [
        {
          title: "Daily report",
          fallback: "Daily report",
          color: "Good",
          fields: [
            {
              title: "Current User Count",
              value: user_count,
              short: true
            },
            {
              title: "New User Count",
              value: new_user_count,
              short: true
            },
            {
              title: "New Post Count",
              value: new_post_count,
              short: true
            },
            {
              title: "User Activity",
              value: interactive_user,
              short: true
            },
            {
              value: "<@U0251BX6FLJ>, <@U0251BX6FLJ>"
            }
          ]
        }
      ]
    }
    @params = generate_payload(params)
    self
  end

  def deliver
    response = Net::HTTP.post_form(@uri, @params)
  end

  def generate_payload params
    {
      payload: {}
        .merge(channel: @channel)
        .merge(params).to_json
    }
  end
end
