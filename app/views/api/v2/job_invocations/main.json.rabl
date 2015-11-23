object @job_invocation

extends "api/v2/job_invocations/base"

child :targeting do
  attributes :bookmark_id, :search_query, :targeting_type, :user_id

  child :hosts do
    extends "api/v2/hosts/base"
  end
end

child :last_task do
  attributes :id, :state
end

child :template_invocations do
  attributes :template_id, :template_name
  child :input_values do
    attributes :template_input_name, :template_input_id, :value
  end
end
