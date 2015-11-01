#
# This is mostly copied from active_scaffold,
#   https://github.com/activescaffold/active_scaffold/
#
module ActionView
  class LookupContext
    module ViewPaths
      def find_all_templates(name, partial = false, locals = {})
        prefixes.collect do |prefix|
          view_paths.collect do |resolver|
            temp_args = *args_for_lookup(name, [prefix], partial, locals, {})
            temp_args[1] = temp_args[1][0]
            resolver.find_all(*temp_args)
          end
        end.flatten!
      end
    end
  end
end

module RenderSuper
  def self.included(base) # :nodoc
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)

    # Same as typing in the class
    base.class_eval do
      alias_method_chain :render, :super
    end
  end

  module ClassMethods; end

  module InstanceMethods
    #
    # Adds rendering option.
    #
    # ==render :super
    #
    # This renders the "super" template, i.e. the one hidden by the plugin
    #
    def render_with_super(*args, &block)
      if args.first == :super
        last_view = view_stack.last || {:view => instance_variable_get(:@virtual_path).split('/').last}
        options = args[1] || {}
        options[:locals] ||= {}
        options[:locals].reverse_merge!(last_view[:locals] || {})
        if last_view[:templates].nil?
          last_view[:templates] = lookup_context.find_all_templates(last_view[:view], last_view[:partial], options[:locals].keys)
          last_view[:templates].shift
        end
        options[:template] = last_view[:templates].shift
        view_stack << last_view
        result = render_without_super options
        view_stack.pop
        result
      else
        options = args.first
        if options.is_a?(Hash)
          current_view = {:view => options[:partial], :partial => true} if options[:partial]
          current_view = {:view => options[:template], :partial => false} if current_view.nil? && options[:template]
          current_view[:locals] = options[:locals] if !current_view.nil? && options[:locals]
          view_stack << current_view if current_view.present?
        end
        result = render_without_super(*args, &block)
        view_stack.pop if current_view.present?
        result
      end
    end


    def view_stack
      @_view_stack ||= []
    end
  end
end
ActionView::Base.send(:include, RenderSuper)
