from intcache import levelCached, IntervalValue as IV
from math import exp

def solution(config):
	N = len(config.u)
	X = config.X
	S = config.S
	inf = float("inf")
	nodes = [0]
	@levelCached
	def g(level,z):
		nodes[0]+=1
		if level == N :
			if z * S > X : return IV(0,(X/S,inf))
			else: return IV(1,(-inf,X/S))
		else: 
			x = config.points[level]
			return ( (g(level+1,z*x.u)*x.u*x.pu).reduce(x.u) 
					+ (g(level+1,z*x.d)*x.d*x.pd).reduce(x.d) 
					+ (g(level+1,z)*x.pm))
	@levelCached
	def h(level,z):
		nodes[0]+=1
		if level == N :
			if z * S > X : return IV(0,(X/S,inf))
			else: return IV(1,(-inf,X/S))
		else: 
			x = config.points[level]
			return ( (h(level+1,z*x.u)*x.pu).reduce(x.u) 
				+ (h(level+1,z*x.d)*x.pd).reduce(x.d) 
				+ (h(level+1,z)*x.pm))		

	return ( exp(-config.r*config.deltaT*N)*(X*h(0,1).value - S*g(0,1).value),nodes[0] )

