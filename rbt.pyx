from libcpp.map cimport map 
from libcpp.utility cimport pair
from cython.operator import dereference as deref
from intmap cimport Interval as CppInterval


cdef class Interval:
	cdef CppInterval * wrapped
	property start:
		def __get__(self):
			return self.wrapped.start
	property end:
		def __get__(self):
			return self.wrapped.end

	def __init__ (self,double start, double end):
		self.wrapped = new CppInterval(start,end)

	def __cinit__(self):
		pass

	cpdef Interval intersect(self, Interval other):
		cdef Interval result = Interval.__new__(Interval)
		result.wrapped = self.wrapped.intersect(other.wrapped)
		return result
		

	cpdef Interval reduce(self,double q):
		cdef Interval result = Interval.__new__(Interval)
		result.wrapped = self.wrapped.reduce(q)
		return result

	def __str__(self):
		return "[{},{}]".format(self.start,self.end)






