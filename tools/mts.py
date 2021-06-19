#!/usr/bin/env python3
import struct
import sys
import zlib

class Schematic4:

	class Node:

		id = 0
		name = ""
		prob = 0
		param2 = 0

		def __repr__(self):
			return '<Node %s %d %d>' % (self.name, self.prob, self.param2)

	def __init__(self):
		self.size = (0, 0, 0)
		self.ids = {}
		self.probs = {}
		self.nodes = {}

	def load(self, data):
		magic, version, size_x, size_y, size_z = struct.unpack_from(">IHHHH", data)
		assert magic == 1297371981
		assert version == 4
		self.size = (size_x, size_y, size_z)

		for y in range(self.size[1]):
			self.probs[y] = struct.unpack_from(">B", data, 12 + y)[0]

		num_ids = struct.unpack_from(">H", data, 12 + self.size[1])[0]

		offset = 12 + self.size[1] + 2
		for id in range(num_ids):
			name_length = struct.unpack_from(">H", data, offset)[0]
			self.ids[id] = struct.unpack_from(">%ds" % name_length, data, offset + 2)[0].decode()
			offset += 2 + name_length

		data = zlib.decompress(data[offset:])
		offset = 0

		for z in range(self.size[2]):
			for y in range(self.size[1]):
				for x in range(self.size[0]):
					self.nodes[(x, y, z)] = self.Node()
					self.nodes[(x, y, z)].id = struct.unpack_from(">H", data, offset)[0]
					self.nodes[(x, y, z)].name = self.ids.get(self.nodes[(x, y, z)].id, "")
					offset += 2

		for z in range(self.size[2]):
			for y in range(self.size[1]):
				for x in range(self.size[0]):
					self.nodes[(x, y, z)].prob = struct.unpack_from(">B", data, offset)[0]
					offset += 1

		for z in range(self.size[2]):
			for y in range(self.size[1]):
				for x in range(self.size[0]):
					self.nodes[(x, y, z)].param2 = struct.unpack_from(">B", data, offset)[0]
					offset += 1

	def save(self):
		out = b""

		out += struct.pack(">IHHHH", 1297371981, 4, *self.size)

		for prob in self.probs.values():
			out += struct.pack(">B", prob)

		out += struct.pack(">H", len(self.ids))

		for name in self.ids.values():
			out += struct.pack(">H%ds" % len(name), len(name), name.encode())

		node_out = b""

		for z in range(self.size[2]):
			for y in range(self.size[1]):
				for x in range(self.size[0]):
					node_out += struct.pack(">H", self.nodes[(x, y, z)].id)

		for z in range(self.size[2]):
			for y in range(self.size[1]):
				for x in range(self.size[0]):
					node_out += struct.pack(">B", self.nodes[(x, y, z)].prob)

		for z in range(self.size[2]):
			for y in range(self.size[1]):
				for x in range(self.size[0]):
					node_out += struct.pack(">B", self.nodes[(x, y, z)].param2)

		out += zlib.compress(node_out)

		return out

	def __repr__(self):
		return '<Schematic4 %r %r>' % (self.size, self.ids)

if __name__ == "__main__":
	s = Schematic4()
	fd = open(sys.argv[1], "rb").read()
	s.load(fd)
	print(s)
	sd = s.save()
	assert fd == sd
