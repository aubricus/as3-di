package com.aubricus.di.errors
{
	public class NotImplementedError extends Error
	{
		public function NotImplementedError(message:*="", id:*=0)
		{
			var defaultMsg:String = "Error: call to a non-implemented method ";
			var errorMsg:String = defaultMsg + message;
			
			super(errorMsg, id);
		}
	}
}