require "spec_helper"

RSpec.describe AgenticPpm::Agents::ContractValidationService do
  it "accepts the complete eight-specialist route and identity contract" do
    result = described_class.call

    expect(result).to be_valid
    expect(result.errors).to be_empty
    expect(AgenticPpm::Agents::RuntimeDispatchService::ROUTES.keys).to contain_exactly(
      "PMO", "VRO", "OKR/KPI", "OCM", "Governance", "FinOps", "TMO", "BusinessPlanning"
    )
  end

  it "reports missing routes or identities instead of allowing activation" do
    allow(AgenticPpm::Agents::RuntimeDispatchService).to receive(:const_get).and_call_original
    stub_const(
      "AgenticPpm::Agents::RuntimeDispatchService::ROUTES",
      AgenticPpm::Agents::RuntimeDispatchService::ROUTES.except("PMO")
    )

    result = described_class.call

    expect(result).not_to be_valid
    expect(result.errors).to include("missing runtime routes: PMO")
  end
end
