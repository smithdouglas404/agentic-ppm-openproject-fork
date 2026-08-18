require "spec_helper"

RSpec.describe AgenticPpm::Integrations::HttpClient do
  around do |example|
    previous = ENV["AGENTIC_PPM_ALLOW_INSECURE_SERVICE_URLS"]
    ENV["AGENTIC_PPM_ALLOW_INSECURE_SERVICE_URLS"] = "true"
    example.run
  ensure
    previous.nil? ? ENV.delete("AGENTIC_PPM_ALLOW_INSECURE_SERVICE_URLS") : ENV["AGENTIC_PPM_ALLOW_INSECURE_SERVICE_URLS"] = previous
  end

  it "joins a relative path to a base URL path without duplicating separators" do
    client = described_class.new(base_url: "http://agent-runtime:8000/runtime/", authorization: nil)

    uri = client.send(:request_uri, "/api/openproject/evidence")

    expect(uri.to_s).to eq("http://agent-runtime:8000/runtime/api/openproject/evidence")
  end

  it "rejects an absolute request URL instead of composing an invalid URI" do
    client = described_class.new(base_url: "http://agent-runtime:8000", authorization: nil)

    expect { client.send(:request_uri, "https://untrusted.example/path") }
      .to raise_error(ArgumentError, "Integration request path must be relative")
  end
end
