from config import cfg, Variant,randConfig,gaussConfig
from algo import solution
from calgo import solution as csolution
from timeit import timeit
from math import log

n = 25
vals = [0]
config = gaussConfig(20,.001)
print(timeit("vals[0] = csolution(config)","from __main__ import csolution,config,vals",number = 1))
print(vals[0], n - log(vals[0][1])/log(2) )

# print(timeit("solution(config)","from __main__ import solution,config", number = 1))