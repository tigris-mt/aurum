#!/usr/bin/env python3
import re
import sys

from mts import Schematic4

if __name__ == "__main__":
	s = Schematic4()
	s.load(sys.stdin.buffer.read())
	it = iter(sys.argv[1:])
	for arg in it:
		(match, replace) = (arg, next(it))
		for k,v in s.ids.items():
			s.ids[k] = re.sub(match, replace, v)
	sys.stdout.buffer.write(s.save())
