module AgenticPpm
  class FindingsController < ApplicationController
    load_and_authorize_with_permission_in_project :approve_agentic_ppm_findings

    def review
      finding = AgenticPpm::Finding.find_by!(project: @project, id: params[:id])
      status = params.require(:status).to_s
      note = params[:note]
      finding.review!(status:, reviewer: User.current, note:)

      render json: { finding: serialized_finding(finding) }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: { code: "not_found", message: "Finding is not available in this project scope" } }, status: :not_found
    rescue ActiveRecord::RecordInvalid, ArgumentError => error
      render json: { error: { code: "validation_error", message: error.message } }, status: :unprocessable_entity
    end

    private

    def serialized_finding(finding)
      {
        id: finding.id,
        project_id: finding.project_id,
        agent_run_id: finding.agent_run_id,
        finding_type: finding.finding_type,
        severity: finding.severity,
        status: finding.status,
        narrative: finding.narrative,
        recommendation: finding.recommendation,
        confidence: finding.confidence,
        provenance: finding.provenance,
        evidence_references: finding.evidence_references,
        reviewed_by_id: finding.reviewed_by_id,
        reviewed_at: finding.reviewed_at&.iso8601,
        review_note: finding.review_note
      }
    end
  end
end
