/**

* @author DaYu

* @version 1.0.2

* @date created 2011/04/06

*/

package dayu.static
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Singleton extends EventDispatcher 
	{
		//設定公開變數data(存放所有資料)
		public var data:Object = new Object();
		
		//設定私域變數
		private static var _instance:Singleton;

		//建構Singleton
		public function Singleton(singletonEnforcer:SingletonEnforcer)
		{
			if(! singletonEnforcer is SingletonEnforcer || singletonEnforcer == null)
			{
				throw new Error("Singleton can not create by New.");
			}
		}

		//取得Singleton
		public static function getInstance():Singleton
		{
			//Singleton存在直接回傳、不存在會建構新的Singleton再回傳
			return Singleton._instance ||= new Singleton(new SingletonEnforcer);
		}
		
		//消滅
		public function destroy():void
		{
			_instance = null;
		}
	}
}


internal class SingletonEnforcer {
}