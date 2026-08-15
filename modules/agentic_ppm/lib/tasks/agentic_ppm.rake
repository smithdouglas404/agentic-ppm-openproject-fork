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

    role = Role.find_by(name: project_template.fetch("member_role")) || Role.first
    raise "A project role is required before seeding the representative project" unless role

    member = Member.find_or_initialize_by(project:, principal: current_user)
    member.roles = [role]
    member.save!

    created_work_packages = {}
    template.fetch("work_packages").each do |work_package_template|
      type = Type.find_by(name: work_package_template.fetch("type")) || Type.first
      status = Status.find_by(name: work_package_template.fetch("status")) || Status.default
      raise "A work package type is required before seeding the representative project" unless type
      raise "A work package status is required before seeding the representative project" unless status

      parent = created_work_packages[work_package_template["parent"]]
      work_package = WorkPackage.find_or_initialize_by(project:, subject: work_package_template.fetch("subject"))
      work_package.assign_attributes(
        author: current_user,
        assigned_to: current_user,
        description: work_package_template.fetch("description"),
        type:,
        status:,
        priority: IssuePriority.default,
        parent:
      )
      work_package.save!
      created_work_packages[work_package_template.fetch("key")] = work_package
    end

    idempotency_key = "representative-project:#{project.id}:#{project.updated_at.to_i}"
    AgenticPpm::ProjectProjectionJob.perform_later(project.id, idempotency_key:)

    puts "Representative Agentic PPM project ready: #{project.identifier} (#{project.id})"
  end
end
