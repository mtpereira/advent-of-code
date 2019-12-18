require "./2019/03/lib/wire"

describe Wire do
  context "#initialize" do
    context "when no coordinates are given" do
      subject(:wire) { Wire.new }
      it "creates no lines" do
        expect(wire.lines).to be_empty
      end
    end

    context "when a single coordinate is provided" do
      let(:coordinates) { "R1" }
      subject(:wire) { Wire.new(coordinates) }
      let(:first_line) { wire.lines.first }

      it "creates a line" do
        expect(wire.lines).not_to be_empty
      end

      context "when the first line is created" do
        subject(:points) { first_line.points }
        let(:first_point) { points[0] }
        let(:second_point) { points[1] }
        let(:zero_point) { Point.new(x: 0, y: 0) }

        it "its first point is the zero point" do
          expect(first_point).to eq(zero_point)
        end

        it "its second point is given by the relative coordinate passed on the Wire" do
          expect(second_point).to eq(Point.new(x: 1, y: 0))
        end
      end
    end

    context "when two coordinates are provided" do
      let(:coordinates) { ["R1", "D1"] }
      subject(:wire) { Wire.new(*coordinates) }
      let(:first_line) { wire.lines[0] }
      let(:second_line) { wire.lines[1] }

      it "creates two lines" do
        expect(wire.lines.length).to eq(2)
      end

      context "when the second line is created" do
        subject(:points) { second_line.points }
        let(:first_point) { points[0] }
        let(:second_point) { points[1] }
        let(:first_line_last_point) { first_line.points.last }

        it "its first point is the first line's last point" do
          expect(first_point).to eq(first_line_last_point)
        end

        it "its second point is given by the relative coordinate passed on the Wire" do
          expect(second_point).to eq(Point.new(x: 1, y: -1))
        end
      end
    end
  end

  context "#intersections" do
    subject(:wire) { Wire.new("R8", "U5", "L5", "D3") }

    context "when two wires do not intersect each other" do
      let(:second_wire) { Wire.new("U7", "R6") }
      let(:intersections) { wire.intersections(second_wire) }
      it "returns an empty array" do
        expect(intersections).to be_empty
      end
    end

    context "when two wires intersect each other in one point" do
      let(:second_wire) { Wire.new("U7", "R6", "D4") }
      let(:intersections) { wire.intersections(second_wire) }
      it "returns an array containing intersections" do
        expect(intersections).not_to be_empty
        expect(intersections).to include(Point.new(x: 6, y: 5))
      end
    end
  end
end
