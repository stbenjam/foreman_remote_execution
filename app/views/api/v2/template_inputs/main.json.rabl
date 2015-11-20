object @template_input

extends "api/v2/template_inputs/base"

attributes :fact_name, :variable_name, :puppet_parameter_name

node :options do |input|
  input.options.split(/\r?\n/)
end
