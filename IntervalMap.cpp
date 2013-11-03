#include "IntervalMap.h"



Interval::Interval(double start, double end): start(start), end(end){};
Interval::Interval(const Interval* origin): start(origin->start), end(origin->end){};

Interval * Interval::reduce(double q) const {
	return new Interval(this->start / q, this->end / q);
}
Interval * Interval::intersect(const Interval * other) const{
	double start = this->start,end = this->end;
	if (start < other->start) start = other->start;
	if (end > other->end) end = other->end;
	return new Interval(start,end);
}


IntervalValue::IntervalValue(double value, const Interval* interval): value(value), interval(interval){};
IntervalValue::IntervalValue(const IntervalValue* origin): value(origin->value), interval(origin->interval){};

IntervalValue * IntervalValue::reduce(double q) const{
	return new IntervalValue(this->value, this->interval->reduce(q));
}
IntervalValue * IntervalValue::add(const IntervalValue* other) const{
	return new IntervalValue(this->value + other-> value, this->interval->intersect(other->interval));
}
IntervalValue * IntervalValue::mul(double q) const{
	return new IntervalValue(this->value * q, this->interval);
}
IntervalValue::~IntervalValue(){
	delete this->interval;
}


IntervalCache::IntervalCache():cache(){};
IntervalCache::IntervalCache(const IntervalCache* other):cache(other->cache){};
bool IntervalCache::has(double point) const{
	auto it = cache.lower_bound(point);
	if (it == cache.end()) return false;
	if (((*it).second->interval->start) > point) return false;
	else true;
}
bool IntervalCache::hasUpper(double point) const{
	auto it = cache.lower_bound(point);
	if (it == cache.end()) return false;
	else true;
}
const IntervalValue* IntervalCache::get(double point) const{
	auto it = cache.lower_bound(point);
	if(it == cache.end()) return NULL;
	else return (*it).second;
}
void IntervalCache::put(const IntervalValue* value){
	cache[value->interval->end] = value;
}