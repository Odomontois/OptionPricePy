from intcache import Interval as Int, IntervalValue as Val, IntervalCache as Cache
from config import cfg

a = Int(3,5)
b = Int(4,6)
print(a.intersect(b).reduce(2))

c = Val(5,(2,5))
d = Val(5,b)

print c,d, ((c+d)*3).reduce(2)

m = Cache()

m[float("-inf"),5] = 3
m[6,float("inf")] = 2
print 5.5 in m, 4 in m, 6 in m, m[5], m[6.5]

from algo import solution

print(solution(cfg.mod_60))