describe Hisoka::InternalSpy do
  let(:stack) do
    ["some-ruby-version/lib/ruby/gems/1.8/bundler/gems/hisoka-md5-5ha/lib/hisoka/internal_spy.rb:46:in `select'",
     "some-rails-app-path/app/controllers/projects_controller.rb:18:in `index'",
     ".rbenv/versions/some-ruby-version/some-rails-trace/base.rb:123:in `all'",
     ".rbenv/versions/some-ruby-version/some-rails-trace/belong.rb:456:in `your'",
     ".rbenv/versions/some-ruby-version/some-rails-trace/to_us.rb:789:in `stacktrace'"
    ]
  end

  let(:non_hisoka) do
    [
      "some-rails-app-path/app/controllers/projects_controller.rb:18:in `index'",
      ".rbenv/versions/some-ruby-version/some-rails-trace/base.rb:123:in `all'",
      ".rbenv/versions/some-ruby-version/some-rails-trace/belong.rb:456:in `your'",
      ".rbenv/versions/some-ruby-version/some-rails-trace/to_us.rb:789:in `stacktrace'"
    ]
  end
  let(:erb) do
     ["some-rails-app-path/app/views/projects/index.html.erb:34:in `_run_erb_47app47views47projects47index46html46erb'`"]
  end

  describe "#non_hisoka_stack" do
    before do
      stub_const("Rails", double("Rails constant", logger: nil, root: "some-rails-app-path"))
    end

    let(:spy) do
      Hisoka::InternalSpy.new(double, double, double, double, double)
    end

    it do
      lines = spy.non_hisoka_stack(stack)
      expect(lines).to eq non_hisoka
    end

    it do
      expect(spy.last_hisoka_stack_index(stack)).to eq 0
    end

    it do
      expect(spy.format_stack_trace(non_hisoka)).to eq "app/controllers/projects_controller.rb:18:in `index'"
    end

    it do
      expect(spy.format_stack_trace(erb)).to eq "app/views/projects/index.html.erb:34"
    end
  end
end
