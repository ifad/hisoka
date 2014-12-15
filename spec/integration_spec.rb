require "./lib/hisoka"

describe Hisoka::Routable do
  let(:hisoka) { Hisoka::Routable.new "my spy"}

  def expect_log(value)
    l = lambda {|s|
      if value.is_a?(Regexp)
        s =~ value
      else
        s[value].present?
      end
    }

    expect($stdout).to receive(:puts).
      with(l), "expected #{value}"
  end

  it "logs the spy name" do
    expect_log "my spy"
    hisoka.doesnt_matter
  end

  it "logs messages called" do
    expect_log /this_gets_called/

    hisoka.this_gets_called
  end

  it "logs attributes" do
    expect_log "an argument"

    hisoka.called_with "an argument"
  end

  it "logs multiple calls" do
    expect_log "first"
    expect_log "second"

    hisoka.first
    hisoka.second
  end

  it "is iterable" do
    expect_log "each"
    expect_log "block-inside-each"
    expect_log "inside_loop"
    expect_log "another_inside_loop"
    expect_log "with parameters"

    hisoka.each do |h|
      h.inside_loop
      h.another_inside_loop
      h.one_more "with parameters"
    end
  end
end
