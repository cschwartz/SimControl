require "spec_helper"

describe SimControl::Scenario do
  it "generates options in -- syntax" do
    scenario = SimControl::Scenario.new foo: "bar", baz: 1
    expect(scenario.options).to eq("--foo bar --baz 1")
  end

  it "generates commands by concatenating" do
    scenario = SimControl::Scenario.new "foo", "bar"
    expect(scenario.commands).to eq("foo bar")
  end

  it "generates the complete arguments string" do
    scenario = SimControl::Scenario.new "foo", "bar", baz: "1", qux: 2
    expect(scenario.args).to eq("foo bar --baz 1 --qux 2")
  end
end
