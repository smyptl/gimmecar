module Lib::Forms::Signatures
  extend ActiveSupport::Concern

  included do
    attr_accessor :user_ip, :user_agent

    class << self
      def signature(name)
        # Defines the methods for the signature
        _form_attributes[name] = {:type => :signature}
        define_method(name) { read_attribute(name) }
        define_method("#{name}=") do |value|
          write_signature(name, value)
        end
      end
    end
  end

  private

  def write_signature(attribute, value = {})
    get_attributes[attribute] = parse_signature(value)
  end

  def parse_signature(value)
    return {} if value.blank?

    if value.is_a?(::Signature)
      {
        :id         => value.id,
        :name       => value.name,
        :terms      => value.terms,
        :key        => value.key,
        :created_at => value.created_at,
      }
    else
      {
        :id         => value[:id],
        :name       => value.fetch(:name),
        :terms      => value.fetch(:terms),
        :key        => value[:key],
        :created_at => value[:created_at],
      }
    end
  end

  def parse_signature_for_audit_log(value)
    parse_signature(value).select { |key, _| [:id, :name, :key].include?(key) }
  end

  def save_signature(attribute, params = {})
    signature = read_attribute(attribute)

    return signature if signature[:id]

    signature = ::Signature.create({
      :name       => signature.fetch(:name),
      :terms      => signature.fetch(:terms),
      :user       => params.fetch(:user),
      :user_ip    => params.fetch(:remote_ip),
      :user_agent => params.fetch(:user_agent)
    })

    write_signature(attribute, signature)
  end
end
