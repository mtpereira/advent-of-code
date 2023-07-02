require "./lib/wire"

# Plan is:
# - Represent coordinate pairs as lines, adding the coordinate 0 to the beginning of the wire path;
# - Go through all lines of both wires and check for intersections between the wires;
# - Calculate the distance from these intersections to the 0 coordinate;
# - Return the smallest.
