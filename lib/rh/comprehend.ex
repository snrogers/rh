defmodule RH.AWS do
  require ExAws
  require Logger
  require Jason

  def comprehend(text) do
    config = ExAws.Config.new(:comprehend)

    req_body = %{
      Text: text,
      LanguageCode: "en"
    }

    stringified_req_body = Jason.encode!(req_body)

    {:ok, response} =
      ExAws.Request.request(
        :post,
        "https://comprehend.us-east-1.amazonaws.com/",
        stringified_req_body,
        [
          {"Content-Type", "application/x-amz-json-1.1"},
          {"X-amz-target", "Comprehend_20171127.DetectSentiment"}
        ],
        config,
        :comprehend
      )

    body = Jason.decode!(response.body)

    {body["Sentiment"], body["SentimentScore"]}
  end
end
