from libcpp.map cimport map 
from libcpp.utility cimport pair
from libcpp cimport bool
from cython.operator import dereference as deref
from intmap cimport Interval as CppInterval, IntervalValue as CppIntervalValue, IntervalCache as CppIntervalCache
from collections import Iterable,defaultdict
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

	def __init__(self,double value, interval):
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

cdef IntervalValue _IntervalValue = IntervalValue.__new__(IntervalValue)

cdef class IntervalCache:
	cdef CppIntervalCache wrapped

	cpdef IntervalValue get(self,double point):
		return _IntervalValue.wrap(self.wrapped.get(point))

	cpdef put(self,IntervalValue value):
		self.wrapped.put(value.wrapped)

	cpdef int has(self,double point):
		return self.wrapped.has(point)

	def __getitem__(self,double point):
		return self.get(point)

	def __setitem__(self, interval, double value):
		self.put(IntervalValue(value,interval))

	def __contains__(self,double point):
		return self.has(point)

def cached(func,cacheAttr=None):
	"""returns cached version of func 
	   func must accept single double argument
	   and return value of type IntervalValue
	"""
	cache = IntervalCache()
	def wrapped(val):
		if val in cache: return cache[val]
		else: 
			result = func(val)
			cache.put(result)
			return result

	wrapped.cache = cache 
	return wrapped


def levelCached(func):
	"""returns cached version of func, with multiple caches, recognized by the first argument
	   func must accept two arguments, second should be of type double,
	   and return value of type IntervalValue
	"""
	levelCache = defaultdict(IntervalCache)
	def wrapped(level,double val):
		cache = levelCache[level]
		if cache.has(val): 
			return cache[val]
		else: 
			result = func(level,val)
			if not( result.interval.start <= val <= result.interval.end):
				raise ValueError("Supplied argument{} not in returned interval {}".format(val,result.interval))
			cache.put(result)
			return result
	wrapped.levelCache = levelCache
	return wrapped













