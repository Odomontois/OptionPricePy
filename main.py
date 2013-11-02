import rbt

a = rbt.Interval(3,5)
b = rbt.Interval(4,6)
print(a.intersect(b).reduce(2))
