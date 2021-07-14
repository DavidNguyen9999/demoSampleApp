require "rails_helper"

describe DailyReportSlackService do
  it "should response success" do
    @uri = URI("https://hooks.slack.com/services/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")
    params = {
      attachments: [
        {
          title: "Daily report"
        }
      ]
    }
    @params = DailyReportSlackService.new.generate_payload(params)
    VCR.use_cassette "send dailyreport", record: :once do
      response = Net::HTTP.post_form(@uri, @params)
      expect(response.code).to eq("200")
    end
  end
end
