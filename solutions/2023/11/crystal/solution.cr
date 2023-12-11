input_file = ARGV[0]
part = ARGV[1]

class Map
  @rows : Array(Array(String))
  @expanded_rows : Array(Int32)
  @expanded_cols : Array(Int32)
  @scale : Int32

  def initialize(file, part)
    @rows = File.read_lines(file).map { |line| line.split("") }
    @expanded_rows = @rows.each_index.select { |i| @rows[i].all? { |c| c == "." }}.to_a
    @expanded_cols = @rows[0].each_index.select { |i| @rows.all? { |r| r[i] == "." }}.to_a
    @scale = part == "1" ? 2 : 1_000_000
  end

  def galaxies
    results = [] of Array(Int32)
    @rows.each_with_index do |row, r|
      row.each_with_index do |s, c|
        results << [r, c] if s == "#" 
      end
    end
    results
  end

  def dist(a, b)
    r1, r2 = [a[0], b[0]].sort
    c1, c2 = [a[1], b[1]].sort
    rows = (r1...r2)
    cols = (c1...c2)

    (r2 - r1) + (c2 - c1) + (@scale - 1) * (
      @expanded_rows.count {|r| rows.includes?(r) } + 
      @expanded_cols.count {|c| cols.includes?(c) }
    )
  end

  def all_distances
    (0..galaxies.size-2).flat_map { |a|
      (a+1..galaxies.size-1).map { |b| dist(galaxies[a], galaxies[b]) }
    }.reduce(0.to_i64) { |acc, num| acc + num.to_i64 }
  end
end

puts Map.new(input_file, part).all_distances
