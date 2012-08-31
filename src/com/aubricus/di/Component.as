package com.aubricus.di
{	
	import flash.utils.getDefinitionByName;

	public class Component
	{
		private var _container:Container;
		private var _key:String;
		private var _klass:String;
		
		private var _ref:Class;
		private var _depKeys:Array = [];
		private var _conf:Object;
		private var _shared:Boolean = false;
		
		private var _instance:*;
		
		public function Component(container:Container, key:String, klass:String)
		{			
			_container = container;
			_key       = key;
			_klass     = klass;
			_ref       = getDefinitionByName(_klass) as Class;
		}
		
		public function execute():*
		{
			var result:*;
			
			if(_shared)
			{
				if(!_instance)
				{
					_instance = create();
				}
				
				result = _instance;
			}
			else
			{
				result = create();
			}
			
			return result;
		}
		
		public function depends(key:String):Component
		{
			_depKeys.push(key);
			return this;
		}
		public function configure(...args):Component
		{
			// expects {} at [0] of args
			_conf = args[0];
			return this;
		}
		public function shared(val:Boolean = true):Component
		{
			_shared = val;
			return this;
		}
		
		// helpers
		private function create():*
		{
			var result:* = new _ref();
			var deps:Array;
			
			// get deps
			deps = getDeps(_container, _depKeys);
			
			// if we got a result apply deps
			//
			// flash bug?
			// sending in as {} because args was doing something funky
			// to my objects where i couldn't cast them after they
			// came in as args[0]
			if(deps)
			{
				(result as IDependable).depends({deps:deps});
			}
			if(_conf)
			{
				(result as IConfigurable).configure({conf:_conf});
			}
			
			return result;
		}
		private function getDeps(container:Container, keys:Array):Array
		{
			var result:Array;
			
			if(keys.length > 0)
			{
				result = [];
				var i:uint = 0;
				var l:uint = keys.length;
				
				for(i; i<l; i++)
				{					
					var key:String = keys[i];
					var dep:* = container.get(key);
					result.push(dep);
				}
			}
			
			return result;
		}
	}
}