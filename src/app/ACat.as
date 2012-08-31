package app
{
	import com.aubricus.di.IConfigurable;
	import com.aubricus.di.IDependable;
	import com.aubricus.di.errors.NotImplementedError;

	public class ACat implements IAnimal, IDependable, IConfigurable
	{	
		// abstract class!
		public function ACat(){}
		
		public function depends(...args):void
		{
			throw(new NotImplementedError('@ACat.depends'));
		}
		public function configure(...args):void
		{
			throw(new NotImplementedError('@ACat.configure'));
		}
		public function name():String
		{
			throw(new NotImplementedError('@ACat.name'));
		}
		public function says():String
		{
			throw(new NotImplementedError('@ACat.says'));
		}
	}
}