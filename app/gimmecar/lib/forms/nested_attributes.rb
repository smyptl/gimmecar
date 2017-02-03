module Lib::Forms::NestedAttributes
  extend ActiveSupport::Concern

  included do
    class << self
      def nested_attribute(name, options = {})
        # Creates a nested hash or array (if options[:array] => true). The block
        # passes the same type of attributes available.

        yield td if block_given?

        nested_attributes = ActiveSupport::HashWithIndifferentAccess.new
        attributes.each { |attr| nested_attributes[attr[0]] = { :type => attr[1], :options => (attr[2] || {})}  }

        _form_attributes[name] = {:type => :nested, :attributes => nested_attributes, :options => options}
        define_attribute_read_method(name)
        define_method("#{name}=") do |values|
          write_nested_attribute(name, values)
        end
      end
    end
  end

  private

  def write_nested_attribute(name, values)
    get_attributes[name] = parse_nested_attribute(values, _form_attributes[name][:attributes])
  end

  # Maps through the set of attributes and extracts the params specified
  # by the form. You can pass in either a array of hashes thae include
  # the attributes or you can pass in an ActiveRecord::Base model.
  def parse_nested_attribute(attributes, rules)
    return [] if attributes.blank?
    attributes = attributes.map do |attribute|
      new_values = ActiveSupport::HashWithIndifferentAccess.new
      #Javascript submission sends attributes as a hash ["0", attribute]
      attribute = attribute.last if attribute.is_a?(Array)

      rules.each do |name, settings|
        if attribute.is_a?(Hash)
          value = attribute[name.to_sym]
        else
          value = attribute.send(name)
        end
        new_values[name.to_sym] = parse_attribute(value, settings[:type], settings[:options])
      end
      new_values.compact.blank? ? nil : new_values
    end
    attributes.compact
  end
end
