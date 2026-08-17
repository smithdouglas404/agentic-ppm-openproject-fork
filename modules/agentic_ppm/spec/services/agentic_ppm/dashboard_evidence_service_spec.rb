require "spec_helper"

RSpec.describe AgenticPpm::DashboardEvidenceService do
  Record = Struct.new(:entity_type, :entity_key, :payload, :source_type, :source_id, :projection_state, :observed_at, keyword_init: true)
  Status = Struct.new(:name, :closed) do
    def is_closed?
      closed
    end
  end
  WorkPackage = Struct.new(:id, :subject, :start_date, :due_date, :status, keyword_init: true)

  let(:project) { instance_double(Project) }
  let(:observed_at) { Time.zone.parse("2026-08-17 12:00:00") }
  let(:records) do
    [
      Record.new(entity_type: "project", entity_key: "openproject:project:1", payload: { "name" => "Transformation" }, source_type: "openproject", source_id: 1, projection_state: "projected", observed_at: observed_at),
      Record.new(entity_type: "work_package", entity_key: "openproject:work_package:2", payload: { "subject" => "Release readiness", "type" => { "name" => "Milestone" }, "status" => { "name" => "In progress" }, "due_date" => "2026-08-12" }, source_type: "openproject", source_id: 2, projection_state: "projected", observed_at: observed_at),
      Record.new(entity_type: "relationship", entity_key: "openproject:relationship:follows:2:3", payload: { "relationship_type" => "follows", "from_key" => "openproject:work_package:2", "to_key" => "openproject:work_package:3" }, source_type: "openproject_relation", source_id: 4, projection_state: "projected", observed_at: observed_at),
      Record.new(entity_type: "relationship", entity_key: "openproject:relationship:contains:1:2", payload: { "relationship_type" => "contains", "from_key" => "openproject:project:1", "to_key" => "openproject:work_package:2" }, source_type: "openproject", source_id: 2, projection_state: "projected", observed_at: observed_at)
    ]
  end

  it "filters source-backed relationships, inspects a selected entity, and surfaces only deterministic schedule review signals" do
    result = described_class.new(
      project: project,
      relationship_type: "follows",
      entity_key: "openproject:work_package:2",
      projection_records: records,
      scheduled_work_packages: [
        WorkPackage.new(id: 2, subject: "Release readiness", start_date: Date.new(2026, 8, 1), due_date: Date.new(2026, 8, 12), status: Status.new("In progress", false)),
        WorkPackage.new(id: 3, subject: "Completed work", start_date: Date.new(2026, 8, 1), due_date: Date.new(2026, 8, 10), status: Status.new("Closed", true))
      ],
      reviewable_work_packages: [
        WorkPackage.new(id: 2, subject: "Release readiness", start_date: Date.new(2026, 8, 1), due_date: Date.new(2026, 8, 12), status: Status.new("In progress", false)),
        WorkPackage.new(id: 3, subject: "Incomplete plan", start_date: nil, due_date: nil, status: Status.new("New", false)),
        WorkPackage.new(id: 4, subject: "Completed work", start_date: nil, due_date: nil, status: Status.new("Closed", true))
      ]
    ).call

    expect(result[:relationship_types]).to eq(%w[contains follows])
    expect(result[:relationship_evidence].map(&:entity_key)).to eq(["openproject:relationship:follows:2:3"])
    expect(result[:inspection_attributes]).to include(
      "Name" => "Release readiness",
      "Work package type" => "Milestone",
      "Status" => "In progress"
    )
    expect(result[:source_review_signals]).to include(
      hash_including(kind: "past_due_schedule", work_package_id: 2, due_date: Date.new(2026, 8, 12))
    )
    expect(result[:source_review_signals]).to include(
      hash_including(kind: "missing_schedule", work_package_id: 3, detail: "Missing start date and due date")
    )
  end

  it "returns only a selected source-review alert drill-down that maps to current source evidence" do
    result = described_class.new(
      project: project,
      alert_key: "missing_schedule:3",
      projection_records: records,
      scheduled_work_packages: [],
      reviewable_work_packages: [
        WorkPackage.new(id: 3, subject: "Incomplete plan", start_date: nil, due_date: nil, status: Status.new("New", false))
      ]
    ).call

    expect(result[:selected_source_review_signal]).to include(kind: "missing_schedule", work_package_id: 3)
    expect(result[:source_review_signal_details]).to include(
      "Source work package" => "Incomplete plan",
      "Source detail" => "Missing start date and due date"
    )
  end

  it "does not treat unknown filter, entity, or source-review alert keys as selected evidence" do
    result = described_class.new(
      project: project,
      relationship_type: "blocks",
      entity_key: "openproject:work_package:999",
      alert_key: "missing_schedule:999",
      projection_records: records,
      scheduled_work_packages: [],
      reviewable_work_packages: []
    ).call

    expect(result[:selected_relationship_type]).to be_nil
    expect(result[:relationship_evidence].size).to eq(2)
    expect(result[:selected_entity_key]).to be_nil
    expect(result[:inspected_entity]).to be_nil
    expect(result[:selected_source_review_signal]).to be_nil
  end
end
