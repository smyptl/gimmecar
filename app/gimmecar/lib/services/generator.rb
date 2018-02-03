class Lib::Services::Generator

  attr_reader :rules, :query

  def initialize(rules:, query:)
    @rules = rules
    @query = query
  end

  def fetch
    create(rules: @rules, query: @query)
  end

  private

  def create(rules:, query:)
    send("send_#{rules.fetch(:type)}", rules: rules, query: query)
  end

  def create_object(rules:, query:)
    output = {}
    output[:id]     = id(rules, query)
    output[:object] = name(rules)

    rules.fetch(:attributes).each do |name, rule|
      q = query.send(query_name(name, r))

      #if rule[:options][:if] && rule[:options][:if].call(q)
      output[name] = create(rules: r, query: q)
    end

    output
  end

  def create_collection(rules:, query:)
    output = {}
    output[:object] = :list

    output[:data] = []
    query.send(query_name(name(rules), rules)).each do |q|
      output[:data] << create_object(rules: rules.fetch(:attributes), query: q)
    end

    output
  end

  def create_value(rules:, query:)
  end

  def query_name(name, rules)
    rules[:options][:as] || name
  end

  def name(rules)
    rules[:name].singularize
  end

  def id(rules, query)
    query.send(rules[:as] || :id)
  end
end
