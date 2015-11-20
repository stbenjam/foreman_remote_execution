module Api
  module V2
    class TemplateInputsController < ::Api::V2::BaseController
      include ::Api::Version2
      include ::Foreman::Renderer

      before_filter :find_required_nested_object
      before_filter :find_resource, :only => %w{show update destroy clone}

      api :GET, "/job_templates/:job_template_id/template_inputs", N_("List template inputs")
      param :job_template_id, :identifier, :required => true
      param_group :search_and_pagination, ::Api::V2::BaseController
      def index
        @template_inputs = nested_obj.template_inputs.search_for(*search_options).paginate(paginate_options)
      end

      api :GET, "/job_templates/:job_template_id/template_inputs/:id", N_("Show template input details")
      param :job_template_id, :identifier, :required => true
      param :id, :identifier, :required => true
      def show
      end

      def_param_group :template_input do
        param :template_input, Hash, :required => true, :action_aware => true do
          param :name, String, :required => true, :desc => N_('Template name')
          param :input_type, String, :required => true, :desc => N_('Input type')
          param :fact_name, String, :required => false, :desc => N_('Fact name')
          param :variable_name, String, :required => false, :desc => N_('Variable name')
          param :puppet_parameter_name, String, :required => false, :desc => N_('Puppet parameter name')
          param :options, Array, :required => false, :desc => N_('Selectable values for user inputs')
        end
      end

      api :POST, "/job_templates/:job_template_id/template_inputs/", N_("Create a template input")
      param_group :template_input, :as => :create
      def create
        params[:options] = params[:options].join("\n")
        @template_input = TemplateInput.new(params[:template_input].merge(:template_id => job_template))
        process_response @template_input.save
      end

      api :DELETE, "/job_templates/:job_template_id/template_inputs/:id", N_("Delete a job template")
      param :job_template_id, :identifier, :required => true
      param :id, :identifier, :required => true
      def destroy
        process_response @template_input.destroy
      end

      def resource_name(nested_resource = nil)
        nested_resource || 'template_input'
      end

      private

      def job_template
        @nested_obj
      end

      def resource_class
        TemplateInput
      end
    end
  end
end
