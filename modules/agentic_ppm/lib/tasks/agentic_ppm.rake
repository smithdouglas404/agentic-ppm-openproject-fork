require "yaml"

namespace :agentic_ppm do
  desc "Create or update the controlled representative OpenProject project and enqueue ontology projection"
  task seed_representative_project: :environment do
    template_path = Rails.root.join("config/agentic_ppm/representative_project.yml")
    template = YAML.safe_load_file(template_path, aliases: true)
    project_template = template.fetch("project")
    current_user = User.admin.first || User.first

    raise "A controlled OpenProject user is required before seeding the representative project" unless current_user

    project = Project.find_or_initialize_by(identifier: project_template.fetch("identifier"))
    project.assign_attributes(
      name: project_template.fetch("name"),
      description: project_template.fetch("description"),
      enabled_module_names: project_template.fetch("enabled_modules"),
      workspace_type: "project"
    )
    project.save!

    role = ProjectRole.find_or_create_by!(name: project_template.fetch("member_role"))

    member = Member.find_or_initialize_by(project:, principal: current_user)
    member.roles = [role]
    member.save!

    created_work_packages = {}
    template.fetch("work_packages").each do |work_package_template|
      type = Type.find_or_create_by!(name: work_package_template.fetch("type"))
      ProjectType.find_or_create_by!(project:, type:)
      status = Status.find_or_create_by!(name: work_package_template.fetch("status"))
      priority = IssuePriority.default || IssuePriority.find_or_create_by!(name: "Normal") do |created_priority|
        created_priority.is_default = true
      end

      parent = created_work_packages[work_package_template["parent"]]
      work_package = WorkPackage.find_or_initialize_by(project:, subject: work_package_template.fetch("subject"))
      work_package.assign_attributes(
        author: current_user,
        assigned_to: current_user,
        description: work_package_template.fetch("description"),
        type:,
        status:,
        priority:,
        parent:
      )
      work_package.save!
      created_work_packages[work_package_template.fetch("key")] = work_package
    end

    idempotency_key = "representative-project:#{project.id}:#{project.updated_at.to_i}"
    AgenticPpm::ProjectProjectionJob.perform_later(project.id, idempotency_key:)

    puts "Representative Agentic PPM project ready: #{project.identifier} (#{project.id})"
  end

  desc "Project the controlled representative project and work packages into persisted ontology records"
  task run_projection: :environment do
    template_path = Rails.root.join("config/agentic_ppm/representative_project.yml")
    template = YAML.safe_load_file(template_path, aliases: true)
    identifier = template.fetch("project").fetch("identifier")
    project = Project.find_by!(identifier:)
    idempotency_key = "representative-projection:#{project.id}:#{project.updated_at.to_i}"

    AgenticPpm::ProjectProjectionJob.perform_now(project.id, idempotency_key:)

    puts "Representative Agentic PPM projection complete: #{project.identifier} (#{project.id})"
  end
end
