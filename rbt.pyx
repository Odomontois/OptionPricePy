from libcpp.map cimport map 
from libcpp.utility cimport pair
from cython.operator import dereference as deref


cdef class Interval:
	cdef double start
	cdef double end  
	def __cinit__ (self, double start, double end):
		self.start = start
		self.end = end
	cpdef Interval intersect(Interval self, Interval int):
		cdef start = self.start if self.start > int.start else int.start
		cdef end = self.end if self.end < int.end else int.end
		return Interval(start,end)
	def __str__(self):
		return "[{},{}]".format(self.start,self.end)







