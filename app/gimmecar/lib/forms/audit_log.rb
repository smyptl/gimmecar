module Lib::Forms::AuditLog
  extend ActiveSupport::Concern

  included do
    set_callback :save, :before, :old_attributes
    set_callback :save, :after, :log
  end

  private

  def log
    log! unless attribute_changes.blank?
  end

  def log!
    @log ||= ::AuditLog.log(log_params.merge({ :attribute_changes => attribute_changes }))
  end

  def new_data_model
    raise Lib::Errors::NotImplemented
  end

  def old_data_model
    raise Lib::Errors::NotImplemented
  end

  def log_params
    raise Lib::Errors::NotImplemented
  end

  def old_attributes
    @old_attributes ||= retrieve_attributes(old_data_model)
  end

  def new_attributes
    @new_attributes ||= retrieve_attributes(new_data_model)
  end

  def attribute_changes
    return @attribute_changes if @attribute_changes
    return @attribute_changes = new_attributes unless old_attributes

    @attribute_changes = {}
    self._form_attributes.each do |attr_name, type|
      old_attribute = old_attributes[attr_name.to_sym]
      new_attribute = new_attributes[attr_name.to_sym]
      @attribute_changes[attr_name.to_sym] = [old_attribute, new_attribute] if new_attribute != old_attribute
    end
    @attribute_changes
  end

  def retrieve_attributes(model)
    attrs = {}
    self._form_attributes.each do |attribute, setting|
      value = model.public_send(attribute)
      case setting[:type]
      when :document
        attrs[attribute] = parse_document_for_audit_log(value, setting[:options])
      when :nested
        attrs[attribute] = parse_nested_attribute(value, setting[:attributes])
      when :signature
        attrs[attribute] = parse_signature_for_audit_log(value)
      else
        attrs[attribute] = parse_attribute(value, setting[:type], setting[:options])
      end
    end
    attrs
  end
end
