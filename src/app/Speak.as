package app
{
	public class Speak implements ICanTalk
	{
		public function Speak()
		{
		}
		
		public function speak(says:String):String
		{
			return says;
		}
	}
}