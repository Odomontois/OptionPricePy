import json

class Point:
	def __init__(self,u,d,pu,pd,pm):
		self.u = u
		self.d = d
		self.pu = pu
		self.pd = pd
		self.pm = pm

class Variant:
	def __init__(self,dict):
		self.__dict__  = dict
		if 'pd' not in dict: self.pd = [1 - pu for pu in self.pu]
		self.pm = [1 - pu - pd for pu,pd in zip(self.pu,self.pd)]
		if 'd' not in dict: self.d = [1. / u for u in self.u]
		self.points = [Point(u,d,pu,pd,pm ) for u,d,pu,pd,pm in zip(self.u,self.d,self.pu,self.pd,self.pm)]

class Config:
	def __init__(self,name):
		cfg = json.load(open(name))
		for name in cfg:
			variant = Variant(cfg[name])
			setattr(self,name,variant)

cfg = Config("config.json")

