RSpec::Matchers.define :contain do |expected|
  match_for_should do |actual|
    expected.all? { |e| actual.keys.include?(e) }
  end
end
RSpec::Matchers.define :only_contain do |expected|
  match_for_should do |actual|
    actual.should contain(expected)
    actual.keys.all? { |a| expected.include?(a) }
  end
end
