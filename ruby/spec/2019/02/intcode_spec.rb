require "./2019/02/lib/intcode"

describe Intcode do
  context "when the provided code is empty" do
    let(:code) { [] }
    let(:output) { subject.run(code) }

    it "returns an empty output" do
      expect(subject.run(code)).to eq []
    end
  end

  context "when provided with an empty instruction" do
    let(:code) { [99] }
    let(:output) { subject.run(code) }

    it "returns the same empty instruction" do
      expect(output).to eq code
    end
  end

  context "when provided with code starting with OPCODE99" do
    let(:code) do
      [
        99,
        1, 0, 0, 1
      ]
    end
    let(:output) { subject.run(code) }

    it "returns the same code" do
      expect(output).to eq code
    end
  end

  context "when running an opcode 1 instruction" do
    let(:code) { [1, 0, 0, 0, 99] }
    let(:output) { subject.run(code) }
    let(:expected) { [2, 0, 0, 0, 99] }

    it "returns the code with the instruction's results in the expected positions" do
      expect(output).to eq expected
    end
  end

  context "when running an opcode 2 instruction" do
    let(:code) { [2, 3, 0, 3, 99] }
    let(:output) { subject.run(code) }
    let(:expected) { [2, 3, 0, 6, 99] }

    it "returns the code with the instruction's results in the expected positions" do
      expect(output).to eq expected
    end
  end

  context "when running code with 2 instructions" do
    let(:code) do
      [
        1, 0, 0, 0,
        2, 4, 4, 4,
        99
      ]
    end
    let(:output) { subject.run(code) }
    let(:expected) do
      [
        2, 0, 0, 0,
        4, 4, 4, 4,
        99
      ]
    end

    it "returns the code with the instruction's results in the expected positions" do
      expect(output).to eq expected
    end
  end

  context "when running a more complex program" do
    let(:code) do
      [
        1, 1, 1, 4,
        99,
        5, 6, 0, 99
      ]
    end
    let(:output) { subject.run(code) }
    let(:expected) do
      [30, 1, 1, 4, 2, 5, 6, 0, 99]
    end

    it "returns the code with the instruction's results in the expected positions" do
      expect(output).to eq expected
    end
  end
end
