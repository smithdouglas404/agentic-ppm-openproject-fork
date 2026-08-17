module AgenticPpm
  class DashboardEvidenceService
    RELATIONSHIP_LIMIT = 100
    ENTITY_LIMIT = 100
    SIGNAL_LIMIT = 12

    def initialize(project:, relationship_type: nil, entity_key: nil, alert_key: nil, projection_records: nil, scheduled_work_packages: nil, reviewable_work_packages: nil)
      @project = project
      @relationship_type = relationship_type
      @entity_key = entity_key
      @alert_key = alert_key
      @projection_records = projection_records
      @scheduled_work_packages = scheduled_work_packages
      @reviewable_work_packages = reviewable_work_packages
    end

    def call
      records = projected_records
      relationships = records.select { |record| record.entity_type == "relationship" }
      entities = records.select { |record| %w[project work_package actor].include?(record.entity_type) }
      relationship_types = relationships.filter_map { |record| payload_for(record)["relationship_type"].presence }.uniq.sort
      selected_relationship_type = relationship_types.include?(@relationship_type) ? @relationship_type : nil
      selected_entity_key = entities.map(&:entity_key).include?(@entity_key) ? @entity_key : nil
      scheduled = scheduled_records
      source_review_signals = source_review_signals(reviewable_records)
      selected_source_review_signal = source_review_signals.find { |signal| signal.fetch(:key) == @alert_key }

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
        source_review_signals: source_review_signals,
        source_review_signal_options: source_review_signals.map { |signal| [signal.fetch(:label), signal.fetch(:key)] },
        selected_source_review_signal: selected_source_review_signal,
        source_review_signal_details: source_review_signal_details(selected_source_review_signal)
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

    def reviewable_records
      return @reviewable_work_packages if @reviewable_work_packages

      @project.work_packages
              .includes(:type, :status)
              .order(:id)
              .to_a
    end

    def source_review_signals(work_packages)
      work_packages.filter_map do |work_package|
        next if work_package.status.respond_to?(:is_closed?) && work_package.status.is_closed?

        if work_package.start_date.blank? || work_package.due_date.blank?
          review_signal(
            kind: "missing_schedule",
            work_package: work_package,
            summary: "Open work package has an incomplete schedule",
            detail: missing_schedule_detail(work_package)
          )
        elsif work_package.due_date < Date.current
          review_signal(
            kind: "past_due_schedule",
            work_package: work_package,
            summary: "Open work package is past its due date",
            detail: "Due date #{work_package.due_date} is before the current date"
          )
        end
      end.first(SIGNAL_LIMIT)
    end

    def review_signal(kind:, work_package:, summary:, detail:)
      {
        key: "#{kind}:#{work_package.id}",
        kind: kind,
        label: "#{work_package.subject} — #{summary}",
        work_package_id: work_package.id,
        subject: work_package.subject,
        start_date: work_package.start_date,
        due_date: work_package.due_date,
        status: work_package.status.name,
        summary: summary,
        detail: detail
      }
    end

    def missing_schedule_detail(work_package)
      missing_fields = []
      missing_fields << "start date" if work_package.start_date.blank?
      missing_fields << "due date" if work_package.due_date.blank?
      "Missing #{missing_fields.join(' and ')}"
    end

    def source_review_signal_details(signal)
      return {} unless signal

      {
        "Signal" => signal.fetch(:summary),
        "Source work package" => signal.fetch(:subject),
        "Source work package ID" => signal.fetch(:work_package_id),
        "Status" => signal.fetch(:status),
        "Start date" => signal[:start_date],
        "Due date" => signal[:due_date],
        "Source detail" => signal.fetch(:detail)
      }.compact
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
