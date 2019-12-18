class Wire
  def initialize(*coordinates)
    @lines = []
    return if coordinates.empty?

    coordinates.unshift("0")
    (0..coordinates.length - 2).each do |i|
      @lines = @lines.append(Line.new(coordinates[i], coordinates[i + 1]))
    end
    puts @lines
  end

  def lines
    @lines
  end

  def intersections(other)
    points = []
    @lines.each do |line|
      other.lines.each do |other_line|
        intersection = line.intersection(other_line)
        points = points.append(intersection) if intersection == true
      end
    end
    puts "intersections: #{points}"
    points
  end
end

class Line
  def initialize(first_coordinate, second_coordinate)
    @start_point, @end_point = parse_points(first_coordinate, second_coordinate)
  end

  def points
    [@start_point, @end_point]
  end

  def start_point
    @start_point
  end

  def end_point
    @end_point
  end

  def to_s
    "#{@start_point} -> #{@end_point}"
  end

  def intersection(other)
    div = calculate_div(other)
    puts "div #{div}"
    return false if div == 0

    d = Point.new(x: det(*points), y: det(*other.points))
    x = det(d, xdiff(other)) / div
    y = det(d, ydiff(other)) / div

    puts "intersection point: #{x}, #{y}"
    point = Point.new(x: x, y: y)
    if contains?(point) && other.contains?(point)
      return point
    end

    false
  end

  def contains?(point)
    point.x >= start_point.x && point.x <= end_point.x && point.y >= start_point.y && point.y <= end_point.y
  end

  private

    def calculate_div(other)
      det(xdiff(other), ydiff(other))
    end

    def xdiff(other)
      Point.new(x: start_point.x - other.start_point.x, y: end_point.x - other.end_point.x)
    end

    def ydiff(other)
      Point.new(x: start_point.y - other.start_point.y, y: end_point.y - other.end_point.y)
    end

    def det(a, b)
      puts "det a #{a} b #{b}"
      a.x * b.y - a.y * b.x
    end

    def parse_points(first, second)
      x, y = 0, 0
      points = []
      [first, second].each do |c|
        case c
        when "0"
          x, y = 0, 0
        when /^R([1-9]+)/
          x += $1.to_i
        when /^L([1-9]+)/
          x -= $1.to_i
        when /^U([1-9]+)/
          y += $1.to_i
        when /^D([1-9]+)/
          y -= $1.to_i
        else
          raise InvalidCoordinate.new("the coordinate #{c} is invalid")
        end
        points = points.append(Point.new(x: x, y: y))
      end

      points
    end
end

class InvalidCoordinate < StandardError
end

class Point
  def initialize(x:, y:)
    if x == nil || y == nil
      @nil = true
    end

    @x, @y = x, y
  end

  def x
    @x
  end

  def y
    @y
  end

  def coordinates
    [@x, @y]
  end

  def ==(other)
    coordinates === other.coordinates
  end

  def to_s
    "x: #{@x}, y: #{@y}"
  end

  def nil?
    @nil
  end
end
