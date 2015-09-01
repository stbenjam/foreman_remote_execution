require 'test_plugin_helper'

describe JobTemplate do
  context 'cloning' do
    let(:job_template) { FactoryGirl.build(:job_template, :with_input) }

    describe '#dup' do
      it 'duplicates also template inputs' do
        duplicate = job_template.dup
        duplicate.wont_equal job_template
        duplicate.template_inputs.wont_be_empty
        duplicate.template_inputs.first.wont_equal job_template.template_inputs.first
        duplicate.template_inputs.first.name.must_equal job_template.template_inputs.first.name
      end
    end
  end

  context 'importing an erb template' do
    let(:template) do
      template = <<-END_TEMPLATE
      <%#
      kind: job_template
      name: Service Restart
      job_name: Service Restart
      provider_type: Ssh
      template_inputs:
      - name: service_name
        input_type: user
        required: true
      %>

      service <%= input("service_name") %> restart
      END_TEMPLATE

      JobTemplate.import(template, :default => true)
    end

    it 'sets the name' do
      template.name.must_equal 'Service Restart'
    end

    it 'has a template' do
      template.template.squish.must_equal 'service <%= input("service_name") %> restart'
    end

    it 'imports inputs' do
      template.template_inputs.first.name.must_equal 'service_name'
    end

    it 'sets additional options' do
      template.default.must_equal true
    end
  end
end
