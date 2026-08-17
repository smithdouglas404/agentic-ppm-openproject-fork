module AgenticPpm
  class DashboardEvidenceService
    RELATIONSHIP_LIMIT = 100
    ENTITY_LIMIT = 100
    SIGNAL_LIMIT = 12

    def initialize(project:, relationship_type: nil, entity_key: nil, projection_records: nil, scheduled_work_packages: nil)
      @project = project
      @relationship_type = relationship_type
      @entity_key = entity_key
      @projection_records = projection_records
      @scheduled_work_packages = scheduled_work_packages
    end

    def call
      records = projected_records
      relationships = records.select { |record| record.entity_type == "relationship" }
      entities = records.select { |record| %w[project work_package actor].include?(record.entity_type) }
      relationship_types = relationships.filter_map { |record| payload_for(record)["relationship_type"].presence }.uniq.sort
      selected_relationship_type = relationship_types.include?(@relationship_type) ? @relationship_type : nil
      selected_entity_key = entities.map(&:entity_key).include?(@entity_key) ? @entity_key : nil
      scheduled = scheduled_records

      {
        projection_summary: records.group_by(&:entity_type).transform_values(&:size),
        relationship_types: relationship_types,
        selected_relationship_type: selected_relationship_type,
        relationship_evidence: relationships
                                 .then { |scope| selected_relationship_type ? scope.select { |record| payload_for(record)["relationship_type"] == selected_relationship_type } : scope }
                                 .first(RELATIONSHIP_LIMIT),
        entity_options: entities.first(ENTITY_LIMIT).map { |record| [entity_label(record), record.entity_key] },
        selected_entity_key: selected_entity_key,
        inspected_entity: entities.find { |record| record.entity_key == selected_entity_key },
        inspection_attributes: inspection_attributes(entities.find { |record| record.entity_key == selected_entity_key }),
        scheduled_work_packages: scheduled.first(12),
        source_review_signals: source_review_signals(scheduled)
      }
    end

    private

    def projected_records
      return @projection_records if @projection_records

      ProjectionRecord.where(project: @project).order(updated_at: :desc).to_a
    end

    def scheduled_records
      return @scheduled_work_packages if @scheduled_work_packages

      @project.work_packages
              .where.not(start_date: nil)
              .includes(:type, :status)
              .order(:start_date, :id)
              .to_a
    end

    def source_review_signals(work_packages)
      work_packages.filter_map do |work_package|
        next unless work_package.due_date.present? && work_package.due_date < Date.current
        next if work_package.status.respond_to?(:is_closed?) && work_package.status.is_closed?

        {
          kind: "past_due_schedule",
          work_package_id: work_package.id,
          subject: work_package.subject,
          due_date: work_package.due_date,
          status: work_package.status.name
        }
      end.first(SIGNAL_LIMIT)
    end

    def inspection_attributes(record)
      return {} unless record

      payload = payload_for(record)
      attributes = {
        "Entity key" => record.entity_key,
        "Entity type" => record.entity_type.humanize,
        "Source system" => record.source_type,
        "Source record" => record.source_id,
        "Projection state" => record.projection_state,
        "Observed at" => record.observed_at,
        "Name" => payload["subject"] || payload["name"],
        "Identifier" => payload["identifier"],
        "Work package type" => payload.dig("type", "name"),
        "Status" => payload.dig("status", "name"),
        "Start date" => payload["start_date"],
        "Due date" => payload["due_date"],
        "Parent work package" => payload["parent_id"]
      }

      attributes.compact.reject { |_label, value| value.respond_to?(:blank?) ? value.blank? : false }
    end

    def entity_label(record)
      payload = payload_for(record)
      name = payload["subject"].presence || payload["name"].presence || payload["identifier"].presence || record.entity_key
      "#{name} (#{record.entity_type.humanize})"
    end

    def payload_for(record)
      record.payload.to_h
    end
  end
end
