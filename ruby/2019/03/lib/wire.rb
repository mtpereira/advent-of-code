class Wire
  def initialize(*coordinates)
    @lines = []
    return if coordinates.empty?

    coordinates.unshift("0")
    (0..coordinates.length - 2).each do |i|
      @lines = @lines.append(
        Line.new(
          *parse_points(coordinates[i], coordinates[i + 1])
        )
      )
    end
  end

  def lines
    @lines
  end

  def intersections(other)
    points = []
    @lines.each do |line|
      other.lines.each do |other_line|
        intersection = line.intersection(other_line)
        points = points.append(intersection) unless intersection.nil?
      end
    end
    puts "intersections: #{points}"
    points
  end

  private

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

class Line
  attr_reader :start_point, :end_point, :a, :b

  def initialize(start_point, end_point)
    @start_point, @end_point = start_point, end_point
    @a = (start_point.y - end_point.y).fdiv(start_point.x - end_point.x)
    @b = start_point.y - @a * start_point.x
  end

  def points
    [@start_point, @end_point]
  end

  def to_s
    "y = #{@a}x + #{@b}"
  end

  def lines_intersect?(other)
    bounding_boxes_intersect?(other) && touches?(other) && other.touches?(self)
  end

  def intersection(other)
    return nil if @a == other.a

    x = (other.b - @b).fdiv(@a - other.a)
    y = @a * x + @b
    Point.new(x: x, y: y) unless (x.infinite? || x.nan?) || (y.infinite? || y.nan?)
  end

  def contains?(point)
    point.x >= start_point.x && point.x <= end_point.x && point.y >= start_point.y && point.y <= end_point.y
  end

  def bounding_box
    first = Point.new(
      x: points.map(&:x).minmax.first,
      y: points.map(&:y).minmax.first
    )
    second = Point.new(
      x: points.map(&:x).minmax.last,
      y: points.map(&:y).minmax.last
    )
    [first, second]
  end

  def touches?(other)
    contains?(other.start_point) || contains?(other.end_point) ||
      (other.start_point.right_of?(self) ^ other.end_point.right_of?(self))
  end

  private

    def bounding_boxes_intersect?(other)
      a, b = bounding_box, other.bounding_box
      a[0].x <= b[1].x \
        && a[1].x >= b[0].x \
        && a[0].y <= b[1].y \
        && a[1].y >= b[0].y
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

  def right_of?(line)
    moved_line = Line.new(
      Point.new(x: 0, y: 0),
      Point.new(
        x: line.end_point.x - line.start_point.x,
        y: line.end_point.y - line.start_point.y
      )
    )
    point = Point.new(
      x: x - line.start_point.x,
      y: y - line.start_point.y
    )
    point.cross_product(moved_line.end_point) < 0
  end

  def cross_product(other)
    x * other.y - other.x * y
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
