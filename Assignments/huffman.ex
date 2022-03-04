defmodule Huffman do

  def sample() do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctutation symbols the frequency will of course not
    represent english but it is probably tnot that far off'
  end
  def text() do
    'this is something that we should encode'
  end

  #hejsan jag heter mille
  
  def test() do
    sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    decode = decode_table(tree)
    text = text()
    seq = encode(text, encode)
    decode(seq, decode)
  end

  def freq(sample) do
    freq(sample, [])
  end
  def freq([], freq) do
    freq
  end
  def freq([char | rest], freq) do
    freq(rest, add(char, freq))
  end

  def add(char, []) do [{char, 1}] end
  def add(char, [{char,  n} | rest]) do
    [{char, n+1} | rest]
  end
  def add(char, [h|rest]) do
    [h | add(char, rest)]
  end

  def huffman(freq) do
    new = Enum.sort(freq, fn({_, n}, {_, n2}) -> n < n2 end)
    new_tree(new)
  end

  def new_tree([{huff, _}]) do huff end
  def new_tree([{char1, n1}, {char2, n2} | rest]) do
    new_tree(update({{char1, char2}, n1+n2}, rest))
  end

  def update({char, n}, []) do [{char, n}] end
  def update({char1, n1}, [{char2, n2} | rest]) do
    case n1 < n2 do
      true -> [{char1, n1}, {char2, n2} | rest]
      false -> [{char2, n2} | update({char1, n1}, rest)]
    end
  end


  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  def encode_table(tree) do
    Enum.sort(findPath(tree, [], []), fn({_, path1}, {_, path2}) -> length(path1) < length(path2) end)
  end


  def findPath({char1, char2}, path, acc) do
    left = findPath(char1, [0 | path], acc) #recursively go down left
    findPath(char2, [1 | path], left) #recursively go down right
  end
  def findPath(char, code, acc) do
    [{char, Enum.reverse(code)} | acc]
  end

  def decode_table(tree) do
    findPath(tree, [], [])
  end

  def encode([], _) do [] end
  def encode([char | rest], table) do
    {_, code} = List.keyfind(table, char, 0)
    code ++ encode(rest, table)
  end 

  def decode([], _) do [] end
  def decode(sequence, table) do
    {char, rest} = decode_char(sequence, 1, table)
    [char | decode(rest, table)]
  end
  def decode_char(sequence, n, table) do
    {code, rest} = Enum.split(sequence, n)
    case List.keyfind(table, code, 1) do
      {char, _} ->
        {char, rest}  
      nil ->
        decode_char(sequence, n+1, table)
    end
  end

  def bench(file, n) do
    {text, b} = read(file, n)
    c = length(text)
    {tree, t2} = time(fn -> tree(text) end)
    {encode, t3} = time(fn -> encode_table(tree) end)
    s = length(encode)
    {decode, _} = time(fn -> decode_table(tree) end)
    {encoded, t5} = time(fn -> encode(text, encode) end)
    e = div(length(encoded), 8)
    r = Float.round(e / b, 3)
    {_, t6} = time(fn -> decode(encoded, decode) end)

    IO.puts("text of #{c} characters")
    IO.puts("tree built in #{t2} ms")
    IO.puts("table of size #{s} in #{t3} ms")
    IO.puts("encoded in #{t5} ms")
    IO.puts("decoded in #{t6} ms")
    IO.puts("source #{b} bytes, encoded #{e} bytes, compression #{r}")
  end

  # Measure the execution time of a function.
  def time(func) do
    initial = Time.utc_now()
    result = func.()
    final = Time.utc_now()
    {result, Time.diff(final, initial, :microsecond) / 1000}
  end

 # Get a suitable chunk of text to encode.
  def read(file, n) do
   {:ok, fd} = File.open(file, [:read, :utf8])
    binary = IO.read(fd, n)
    File.close(fd)

    length = byte_size(binary)
    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, chars, rest} ->
        {chars, length - byte_size(rest)}
      chars ->
        {chars, length}
    end
  end


end