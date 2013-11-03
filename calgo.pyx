from libc.math cimport exp
from libc.stdlib cimport malloc,free
from intmap cimport *

cdef extern from "math.h":
	double INFINITY

cpdef solution(object config):
	X = config.X
	deltaT = config.deltaT
	S = config.S
	r = config.r

cdef class Solution:
	cdef int N,nodes
	cdef double X,S,deltaT,r,* u,*d,*pd,*pu,*pm
	cdef IntervalCache ** gCache, ** hCache
	def __cinit__(self, config):
		self.X = config.X
		self.S = config.S
		self.deltaT = config.deltaT
		self.N = len(config.u)
		self.r = config.r
		self.u = <double *>malloc(self.N*sizeof(double))
		self.d = <double *>malloc(self.N*sizeof(double))
		self.pu = <double *>malloc(self.N*sizeof(double))
		self.pd = <double *>malloc(self.N*sizeof(double))
		self.pm = <double *>malloc(self.N*sizeof(double))
		self.gCache = <IntervalCache **>malloc((self.N +1)*sizeof(IntervalCache*))
		self.hCache = <IntervalCache **>malloc((self.N +1)*sizeof(IntervalCache*))
		for i in range(self.N):
			self.u[i] = config.u[i]
			self.d[i] = config.d[i]
			self.pu[i] = config.pu[i]
			self.pd[i] = config.pd[i]
			self.pm[i] = config.pm[i]
			self.gCache[i] = new IntervalCache()
			self.hCache[i] = new IntervalCache()
		self.nodes = 0
		self.gCache[self.N] = new IntervalCache()
		self.hCache[self.N] = new IntervalCache()


	cdef const IntervalValue* g(self,int level,double z):
		cdef const IntervalValue * result
		cdef double u = self.u[level]
		cdef double d = self.d[level]
		cdef double pu = self.pu[level]
		cdef double pd = self.pd[level]
		cdef double pm = self.pm[level]
		if self.gCache[level].has(z):
			return self.gCache[level].get(z)
		else:
			self.nodes+=1
			if level == self.N:
				if (z * self.S) > self.X : result =  new IntervalValue(0,new Interval(self.X/self.S,INFINITY))
				else: result = new IntervalValue(1,new Interval(-INFINITY,self.X/self.S))
			else:

				result = self.g(level+1,z*u).mul(u*pu).reduce(u).add(
				 	     self.g(level+1,z*d).mul(d*pd).reduce(d)).add(
				 	     self.g(level+1,z).mul(pm))
			self.gCache[level].put(result)
			return result

	cdef const IntervalValue* h(self,int level,double z):
		cdef const IntervalValue * result
		cdef double u = self.u[level]
		cdef double d = self.d[level]
		cdef double pu = self.pu[level]
		cdef double pd = self.pd[level]
		cdef double pm = self.pm[level]
		if self.hCache[level].has(z):
			return self.hCache[level].get(z)
		else:
			self.nodes+=1
			if level == self.N:
				if (z * self.S) > self.X : result =  new IntervalValue(0,new Interval(self.X/self.S,INFINITY))
				else: result = new IntervalValue(1,new Interval(-INFINITY,self.X/self.S))
			else:

				result = self.h(level+1,z*u).mul(pu).reduce(u).add(
				 	     self.h(level+1,z*d).mul(pd).reduce(d)).add(
				 	     self.h(level+1,z).mul(pm))
			self.hCache[level].put(result)
			return result

	cpdef result(self):
		self.nodes = 0
		return (exp(- self.r * self.deltaT * self.N) * ( self.X  * self.h(0,1).value - self.S * self.g(0,1).value),self.nodes)


	def __del__(self,config):
		free(self.u)
		free(self.d)
		free(self.pu)
		free(self.pd)
		free(self.pm)
		free(self.gCache)
		free(self.hCache)

def solution(config): 
	return Solution(config).result()
