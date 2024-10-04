require 'digest'

input_file = ARGV[0]
part = ARGV[1]

match = part == "1" ? "00000" : "000000"

prefix = File.read(input_file).strip
suffix = 1
suffix += 1 until Digest::MD5.hexdigest("#{prefix}#{suffix}").start_with?(match)
puts suffix
