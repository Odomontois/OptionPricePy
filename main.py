import rbt

a = rbt.Interval(3,5)
b = rbt.Interval(4,6)
print(a.intersect(b).reduce(2))

c = rbt.IntervalValue(5,(2,5))
d = rbt.IntervalValue(5,b)

print c,d, ((c+d)*3).reduce(2)