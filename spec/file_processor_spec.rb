require 'extract_i18n/file_processor'

RSpec.describe ExtractI18n::FileProcessor do
  specify 'normal string' do
    file = <<~DOC
      a = "Hallo Welt"
    DOC
    expect(run(file)).to be == [
      "a = I18n.t(\"models.foo.hallo_welt\")\n", { 'models.foo.hallo_welt' => 'Hallo Welt' }
    ]
  end

  specify 'Heredoc' do
    file = <<~DOC
      a = <<~FOO
        Hallo
        Welt
      FOO
    DOC
    expect(run(file)).to be == [
      "a = I18n.t(\"models.foo.hallo_welt\")\n", { 'models.foo.hallo_welt' => "Hallo\nWelt\n" }
    ]
  end

  specify 'String placeholder' do
    file = <<~DOC
      a = "What date is it: \#{Date.today}!"
    DOC
    expect(run(file)).to be == [
      "a = I18n.t(\"models.foo.what_date_is_it\", date_today: (Date.today))\n", {
        'models.foo.what_date_is_it' => "What date is it: %{date_today}!"
      }
    ]
  end

  specify 'Ignore active record stuff' do
    file = <<~DOC
      has_many :foos, class_name: "FooBar", foreign_key: "foobar"
    DOC
    expect(run(file)).to be == [
      file, {}
    ]
  end

  specify 'Ignore active record functions' do
    file = <<~DOC
      sql = User.where("some SQL Condition is true").order(Arel.sql("Foobar"))
    DOC
    expect(run(file)).to be == [
      file, {}
    ]
  end

  specify 'Ignore regex' do
    file = <<~DOC
      a = /Hallo Welt/
    DOC
    expect(run(file)).to be == [
      file, {}
    ]
  end

  specify 'Ignore active record stuff' do
    file = <<~DOC
      has_many :foos, class_name: "FooBar", foreign_key: "foobar"
    DOC
    expect(run(file)).to be == [
      file, {}
    ]
  end

  def run(string, file_key = 'models.foo')
    temp = Parser::CurrentRuby.parse(string)
    rewriter = ExtractI18n::Transform.new(file_key: file_key, always_yes: true)
    buffer = Parser::Source::Buffer.new('(example)')
    buffer.source = string

    output = rewriter.rewrite(buffer, temp)
    [output, rewriter.i18n_changes]
  end
end