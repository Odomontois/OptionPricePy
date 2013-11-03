from config import cfg, Variant,randConfig
from algo import solution
from calgo import solution as csolution
from timeit import timeit


config = cfg.mod_60
print(timeit("csolution(config)","from __main__ import csolution,config",number = 100))

print(timeit("solution(config)","from __main__ import solution,config", number = 100))