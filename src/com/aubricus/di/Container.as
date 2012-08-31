package com.aubricus.di
{
	public class Container
	{
		private var _comps:Object = {};
		
		public function Container(){}
		
		public function set(key:String, klass:String):Component
		{
			var c:Component = new Component(this, key, klass);
			_comps[key] = c;
			
			return c;
		}
		
		public function get(key:String):*
		{
			var c:Component = _comps[key];
			return c.execute();
		}
	}
}