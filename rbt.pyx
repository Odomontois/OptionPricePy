from libcpp.map cimport map 
from libcpp.utility cimport pair
from cython.operator import dereference as deref
from intmap cimport Interval as CppInterval, IntervalValue as CppIntervalValue
cimport cython


cdef class Wrapper:
	cdef wrap(self,CppInterval* interval):
		cdef Interval wrapper = self.__new__(type(self))
		wrapper.wrapped = interval
		return wrapper	

cdef class Interval(Wrapper):
	cdef CppInterval * wrapped
	property start:
		def __get__(self):
			return self.wrapped.start
	property end:
		def __get__(self):
			return self.wrapped.end

	def __init__ (self,double start, double end):
		self.wrapped = new CppInterval(start,end)

	cpdef Interval intersect(self, Interval other):
		return _Interval.wrap(self.wrapped.intersect(other.wrapped))		

	cpdef Interval reduce(self,double q):
		return _Interval.wrap(self.wrapped.reduce(q))

	def __str__(self):
		return "[{},{}]".format(self.start,self.end)

cdef Interval _Interval = Interval.__new__(Interval)


# cdef class IntervalValue(Wrapper):
# 	cdef CppIntervalValue * wrapped
# 	property value:
# 		def __get__(self):
# 			return self.wrapped.value 
# 	property interval:
# 		def __get__(self):
# 			return _Interval.wrap(self.wrapped.interval)






