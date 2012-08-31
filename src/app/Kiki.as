package app
{
	import flash.utils.getQualifiedClassName;

	public dynamic class Kiki extends ACat
	{
		private var _name:String = "Kiki";
		private var _says:String = "I'm so hungry! Merrrowww Merrroww";
		private var _speak:Speak;
		
		public function Kiki(speak:Speak = null, says:String=null)
		{
			_speak = speak ? speak : _speak;
			_says  = says  ? says  : _says;
			super();
		}
		
		// abstract class overrides
		
		override public function configure(...args):void
		{
			// expects {} at [0] in args
			// expects {conf:{says:""}}
			var conf:Object = args[0].conf;
			_says = conf.says ? conf.says : _says;
		}
		override public function depends(...args):void
		{
			// expects {} at [0] in args
			// expects {deps:[]}
			// expected order, [speak:SpeakObject]
			var deps:Object = args[0].deps;
			_speak = Speak(deps[0]);
		}
		override public function name():String
		{
			return _name;
		}
		override public function says():String
		{
			var result:String = name() + ' says, "..."';
			
			if(_speak)
			{
				result = name() + ' says, "' + _speak.speak(_says) + '"';
			}
			
			return result;
		}
	}
}