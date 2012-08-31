package
{
	import app.ACat;
	import app.IAnimal;
	import app.ICanTalk;
	import app.Kiki;
	import app.Speak;
	
	import com.aubricus.di.Component;
	import com.aubricus.di.Container;
	import com.aubricus.di.errors.NotImplementedError;
	
	import flash.display.Sprite;
	
	import flashx.textLayout.debug.assert;
	
	public class Main extends Sprite
	{
		private var passMsg:String = "Build Status: PASSING";
		private var failMsg:String = "Build Status: FAILING";
		private var testFailMsg:String = "[[ FAILED ]] ";
		private var testPassMsg:String = "[[ PASSED ]]";
		
		private var results:Array = [];
		private var buildStatus:String;
		
		// compiler linking 
		// (necessary to get compiler to include classes 
		//  created with getDefinitoinByName)
		private var ianimal:IAnimal;
		private var acat:ACat;
		private var kiki:Kiki;
		private var icantalk:ICanTalk;
		private var speak:Speak;
		
		public function Main()
		{
			results.push(testSet());
			results.push(testSetGet());
			results.push(testDep());
			results.push(testConfigure());
			results.push(testShared());
			results.push(testNonImplementedError());
			results.push(testNormalInstance());
				
			var pass:Boolean = true;
			
			for(var i:* in results)
			{
				pass = results[i];
				if(!pass) break;
			}
			
			buildStatus = pass ? passMsg : failMsg;
			trace('\n' + buildStatus + '\n');
		}
		
		private function testSet():Boolean
		{
			trace('TEST: "testSet"');
			var result:Boolean = false;
			var c:Container = new Container();
			
			var args:Object = {};
			args.opts = {'value1':'foo', 'value2':'bar'};
			
			try{
				var comp:Component = c.set('ACat', 'app.Kiki', args);
				trace('-> testing Component instance: ', comp);
				result = true;
				trace('-> ' + testPassMsg + '\n');
			}
			catch(e:Error)
			{
				trace('-> ' + testFailMsg, e.message + '\n');
				result = false;
			}
			
			return result;
		}
		private function testSetGet():Boolean
		{
			trace('TEST: "testSetGet"');
			var result:Boolean = false;
			var c:Container = new Container();
			var args:Object = {};
			var cat:ACat;
			
			args.opts = {'value1':'foo', 'value2':'bar'};
			
			try{
				c.set('ACat', 'app.Kiki', args);
				cat = c.get('ACat');
				trace('-> testing cat.says: ' + cat.says());
				
				result = true;
				trace('-> ' + testPassMsg + '\n');
			}
			catch(e:Error)
			{
				trace('-> ' + testFailMsg, e.message + '\n');
				result = false;
			}
			
			return result;
		}
		private function testDep():Boolean
		{
			trace('TEST: "testDep"');
			var result:Boolean = false;
			var c:Container = new Container();
			
			try{
				c.set('ICanTalk', 'app.Speak');
				c.set('ACat', 'app.Kiki').depends('ICanTalk');
				
				var spk:Speak = c.get('ICanTalk');
				trace('-> testing speak.speak: ', spk.speak('"I said something!"'));
				
				var cat:ACat = c.get('ACat');
				trace('-> testing cat.says: ', cat.says());
				
				trace('-> ' + testPassMsg + '\n');
				result = true;
			}
			catch(e:Error)
			{
				trace('-> ' + testFailMsg, e.message + '\n');
				result = false;
			}
			
			return result;
		}
		private function testConfigure():Boolean
		{
			trace('TEST: "testConfigure"');
			var result:Boolean = false;
			var c:Container = new Container();
			
			try{
				c.set('ICanTalk', 'app.Speak');
				c.set('ACat', 'app.Kiki')
					.depends('ICanTalk')
					.configure({says:'Merrrow, wake up and feed me!'});
				
				var cat:ACat = c.get('ACat');
				trace('-> testing cat.says: ', cat.says());
				
				var cat2:ACat = c.get('ACat');
				var conf:Object = {says: 'hi, roow meroow'};
				
				cat2.configure({conf:conf});
				trace('-> testing cat2.says: ', cat2.says());
				
				trace('-> ' + testPassMsg + '\n');
				result = true;
			}
			catch(e:Error)
			{
				trace('-> ' + testFailMsg, e.message + '\n');
				result = false;
			}
			
			return result;
		}
		private function testShared():Boolean
		{
			trace('TEST: "testShared"');
			var result:Boolean = false;
			var c:Container = new Container();
			
			try{
				c.set('ICanTalk', 'app.Speak');
				c.set('ACat', 'app.Kiki')
					.depends('ICanTalk')
					.configure({says:"meow"})
					.shared();
				
				var conf:Object = {says:"We are siamese if you don't please!"};
				var cat1:ACat = c.get('ACat');
				var cat2:ACat = c.get('ACat');
				
				cat2.configure({conf:conf});
				trace('-> testing cat1.says: ', cat1.says());
				trace('-> testing cat2.says: ', cat2.says());
				
				if(cat1.says() == cat2.says())
				{
					trace('->' + testPassMsg + '\n');
					result = true;
				}
				else
				{
					trace('-> ' + testFailMsg + '\n');
					result = false;
				}
			}
			catch(e:Error)
			{
				trace('-> ' + testFailMsg, e.message + '\n');
				result = false;
			}
			
			return result;
		}
		private function testNonImplementedError():Boolean
		{
			trace('TEST: "testNonImplementedError"');
			var result:Boolean = false;
			var acat:ACat = new ACat();
			
			try{
				acat.name();
			}
			catch(e:NotImplementedError){
				trace('-> caught error: ', e.message);
				result = true;
			}
			try{
				acat.says();
			}
			catch(e:NotImplementedError){
				trace('-> caught error: ', e.message);
				result = true;
			}
			try{
				acat.depends();
			}
			catch(e:NotImplementedError){
				trace('-> caught error: ', e.message);
				result = true;
			}
			try{
				acat.configure();
			}
			catch(e:NotImplementedError){
				trace('-> caught error: ', e.message);
				result = true;
			}
			
			if(!result)
				trace('-> ' + testFailMsg + '\n');
			else
				trace('-> ' + testPassMsg + '\n');
			
			return result;
		}
		private function testNormalInstance():Boolean
		{
			trace('TEST: "testNormalInstance"');
			var result:Boolean = false;
			
			var k:Kiki = new Kiki(new Speak(), 'Gimme that chicken nau! :: swipes ::');
			
			try{
				trace('-> testing kiki.says: ', k.says());
				trace('-> ' + testPassMsg);
				result = true;
			}
			catch(e:Error)
			{
				trace('-> ' + testFailMsg, e.message + '\n');
				result = false;
			}
			
			return result;
		}
	
	}
}