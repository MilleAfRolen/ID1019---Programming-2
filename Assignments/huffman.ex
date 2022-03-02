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

  def new_tree() do

  end

  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  def encode_table(tree) do

  end

  def decode_table(tree) do

  end

  def encode(text, table) do

  end

  def decode(sequence, table) do

  end



end