describe "Hisoka::Hashable" do
  before do
    rails = stub_const "Rails", double("Rails constant")
    expect(rails).to receive(:logger).at_least(1).and_return double("logger", info: nil)
    expect(rails).to receive(:root).at_least(1).and_return File.expand_path(File.join(__FILE__), "..")
  end

  it "provides equivalent objects when called with the same arguments" do
    hashable = Hisoka::Routable.new("hashable")
    object = hashable.some_method :an_argument

    expect(object).to eq hashable.some_method :an_argument
  end

  it "provides different objects to different arguments" do
    hashable = Hisoka::Routable.new("my hashable")
    object = hashable.some_method

    expect(object).to_not eq hashable.some_method("different")
  end


  it "has children that are insertable and retrievable from a hash" do
    hashable = Hisoka::Routable.new("hashable")

    storage = {}

    instance = hashable.some_method
    storage[instance] ||= []

    storage[hashable.some_method] << hashable.something_else


    expect(storage[instance]).to eq [hashable.something_else]
    expect(storage[hashable.some_method]).to eq [hashable.something_else]

  end
end
