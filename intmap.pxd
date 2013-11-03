from libcpp.map cimport map
from libcpp cimport bool

cdef extern from "IntervalMap.h":
	cdef cppclass Interval:
		Interval(double, double) nogil except+
		Interval(Interval*) nogil except +
		double start, end
		Interval* intersect(Interval*) nogil
		Interval* reduce(double)nogil

cdef extern from "IntervalMap.h":
	cdef cppclass IntervalValue:
		IntervalValue(IntervalValue* )nogil except +
		IntervalValue(double,Interval*)nogil except +
		double value
		Interval * interval
		IntervalValue * reduce( double) nogil
		IntervalValue * add(IntervalValue *) nogil
		IntervalValue * mul(double) nogil
		
cdef extern from "IntervalMap.h":
	cdef cppclass IntervalCache:
		IntervalCache() nogil except +
		IntervalCache(IntervalCache*) nogil except +
		map[double,const IntervalValue*] nogil
		bool has(double) nogil
		bool hasUpper(double) nogil
		IntervalValue * get(double) nogil
		void put(IntervalValue *)nogil

