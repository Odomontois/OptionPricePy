from libcpp.map cimport map 
from libcpp.utility cimport pair
from cython.operator import dereference as deref
from intmap cimport Interval as CppInterval, IntervalValue as CppIntervalValue
from collections import Iterable
cimport cython



cdef class Interval:
	cdef const CppInterval * wrapped
	property start:
		def __get__(self):
			return self.wrapped.start
	property end:
		def __get__(self):
			return self.wrapped.end

	cdef wrap(self, const CppInterval* interval):
		cdef Interval wrapper = self.__new__(type(self))
		wrapper.wrapped = interval
		return wrapper	

	def __init__ (self,double start, double end):
		self.wrapped = new CppInterval(start,end)

	cpdef Interval intersect(self, Interval other):
		return self.wrap(self.wrapped.intersect(other.wrapped))		

	cpdef Interval reduce(self,double q):
		return self.wrap(self.wrapped.reduce(q))

	def __str__(self):
		return "[{},{}]".format(self.start,self.end)

cdef Interval _Interval = Interval.__new__(Interval)


cdef class IntervalValue:
	cdef const CppIntervalValue * wrapped
	property value:
		def __get__(self):
			return self.wrapped.value 
	property interval:
		def __get__(self):
			return _Interval.wrap(self.wrapped.interval)

	cdef wrap(self, const CppIntervalValue* intervalValue):
		cdef IntervalValue wrapper = self.__new__(type(self))
		wrapper.wrapped = intervalValue
		return wrapper			

	def __init__(self,double value, object interval):
		cdef Interval int
		if type(interval) == Interval:
			int = interval
		elif isinstance(interval,Iterable):
			start,end = interval
			int = Interval(start,end)

		self.wrapped = new CppIntervalValue(value,int.wrapped)

	cpdef IntervalValue reduce(self, double q):
		return self.wrap(self.wrapped.reduce(q))

	cpdef IntervalValue mul(self,double q):
		return self.wrap(self.wrapped.mul(q))

	cpdef IntervalValue add(self, IntervalValue other):
		return self.wrap(self.wrapped.add(other.wrapped))
	def __add__(self,other):
		return self.add(other)

	def __mul__(self,other):
		return self.mul(other)

	def __str__(self):
		return "{{{}}}{}".format(self.value, self.interval)








