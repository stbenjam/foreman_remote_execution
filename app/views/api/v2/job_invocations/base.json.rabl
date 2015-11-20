object @job_invocation

attributes :id, :job_name, :targeting_id

child :last_task do
  attributes :id, :state
end
