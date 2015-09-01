require 'test_plugin_helper'

describe TemplateInvocationInputValue do
  let(:template) { FactoryGirl.build(:job_template, :template => 'service restart <%= input("service_name") -%>') }
  let(:renderer) { InputTemplateRenderer.new(template) }
  let(:job_invocation) { FactoryGirl.create(:job_invocation) }
  let(:template_invocation) { FactoryGirl.build(:template_invocation, :template => template) }
  let(:result) { renderer.render }

  context 'with selectable options' do
    before do
      result # let is lazy
      template.template_inputs << FactoryGirl.build(:template_input, :name => 'service_name', :input_type => 'user',
                                                                     :required => true, :options => "foreman\nhttpd")
    end

    it 'fails with an invalid option' do
      refute_valid FactoryGirl.build(:template_invocation_input_value, :template_invocation => template_invocation,
                                                                       :template_input => template.template_inputs.first,
                                                                       :value => 'sendmail')
    end

    it 'succeeds with valid option' do
      assert_valid FactoryGirl.build(:template_invocation_input_value, :template_invocation => template_invocation,
                                                                       :template_input => template.template_inputs.first,
                                                                       :value => 'foreman')
    end
  end
end
