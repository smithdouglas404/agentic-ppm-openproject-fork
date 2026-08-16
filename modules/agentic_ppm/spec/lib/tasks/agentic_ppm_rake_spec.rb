require "rspec"
require "rake"

RSpec.describe "Agentic PPM rake tasks" do
  around do |example|
    original_application = Rake.application
    Rake.application = Rake::Application.new
    load File.expand_path("../../../lib/tasks/agentic_ppm.rake", __dir__)
    example.run
  ensure
    Rake.application = original_application
  end

  it "registers the controlled representative seed task" do
    task = Rake::Task["agentic_ppm:seed_representative_project"]

    expect(task.prerequisites).to include("environment")
  end

  it "registers the deterministic projection task" do
    task = Rake::Task["agentic_ppm:run_projection"]

    expect(task.prerequisites).to include("environment")
  end
end
