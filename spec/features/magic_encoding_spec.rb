describe "Files missing magic encoding comment" do
  subject(:files_missing_magic_encoding) {
    load File.expand_path('../../../bin/magic_encoding_find', __FILE__)
    magic_encoding_find
  }

  it "should be empty" do
    unless files_missing_magic_encoding.empty?
      count = files_missing_magic_encoding.count
      $stderr.puts <<TXT
There are #{count} files that misses magic encoding comment:

  #{files_missing_magic_encoding.join("\n  ")}

Run command `bin/magic_encoding_fix` to fix them.
TXT
    end

    expect(files_missing_magic_encoding).to be_empty
  end
end
