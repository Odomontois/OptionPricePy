#include <map>

class Interval{
public:
	const double start;
	const double end;
	Interval(double, double);
	Interval(const Interval *);
	Interval* intersect( const Interval*) const;
	Interval* reduce(double) const;
};

class IntervalValue
{
public:
	const double value;
	const Interval * interval;
	IntervalValue(double, const Interval* );
	IntervalValue(const IntervalValue*);
	IntervalValue * reduce(double) const;
	IntervalValue * add(const IntervalValue *) const;
	IntervalValue * mul(double) const ;
	~IntervalValue();
};


class IntervalMap {
public: 
	IntervalMap();

};

class IntervalCache
{
public:
	IntervalCache();
	IntervalCache(const IntervalCache*);
	std::map<double,const IntervalValue*> cache;
	bool has(double) const;
	bool hasUpper(double) const;
	const IntervalValue* get(double) const;
	void put(const IntervalValue *);
};