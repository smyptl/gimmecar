class Lib::Services::Generator

  attr_reader :record, :rules, :query

  def initialize(record:, rules:, query:)
    @record = record
    @rules  = rules
    @query  = query
  end

  def retrieve
    create(rules: @rules, query: @query)
  end

  private

  def create(rules:, query:)
    send("create_#{rules.fetch(:type)}", rules: rules, query: query)
  end

  def create_object(rules:, query:)
    return nil if query.nil?

    output = {}

    output[:object] = name(rules)
    output[:id]     = id(rules, query)

    rules.except(:id).fetch(:attributes).each do |_, rule|
      if rule.fetch(:type) == :attribute
        if (rule[:options][:if] && run(rule[:options][:if], query)) || rule[:options][:if].blank?
          output[rule[:name].to_sym] = attribute(rules: rule, query: query)
        end
      else
        q = query.send(query_name(rules: rule))
        output[rule[:name].to_sym] = create(rules: rule, query: q)
      end
    end

    output
  end

  def create_collection(rules:, query:)
    output = {}
    output[:object] = :list
    output[:count]  = query.count

    output[:data] = []
    query.each do |q|
      output[:data] << create_object(rules: rules, query: q)
    end

    output
  end

  def attribute(rules:, query:)
    if rules[:options][:output]
      run(rules[:options][:output], query)
    else
      query.send(query_name(rules: rules))
    end
  end

  def query_name(rules:)
    rules[:options][:as] || rules[:name]
  end

  def name(rules)
    rules[:name].to_s.singularize
  end

  def id(rules, query)
    query.send(rules.dig(:attributes, :id, :options, :as) || :id)
  end

  def run(method, query)
    record.instance_exec(query, &method)
  end
end
