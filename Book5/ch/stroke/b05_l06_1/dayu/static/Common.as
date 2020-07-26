/**

* @author DaYu

* @version 1.0.3

* @date created 2011/04/22

*/

package dayu.static
{
	public class Common extends Object
	{
		//建構Common
		public function Common(singletonEnforcer:SingletonEnforcer)
		{
			if(! singletonEnforcer is SingletonEnforcer || singletonEnforcer == null)
			{
				throw new Error("Common can not create by New.");
			}
		}
		
		//十位數(不足補0)轉換字串型態
		public static function tensToString(tens:Number):String
		{
			if(tens >= 100)
				throw new Error("Tens is less than 100.");
			
			if(tens < 10)
				return "0" + Math.floor(tens).toString();
			else
				return Math.floor(tens).toString();
		}
		
		//字串轉換布林值型態(模糊比較)
		public static function stringToBoolean(item:String):Boolean
		{
			var trueAry:Array = ["true", "yes", "y", "是", "正確", "對", "開", "開啟"];
			var falseAry:Array = ["false", "no", "n", "否", "錯誤", "錯", "關", "關閉"];
			
			//從正確陣列選找是否有符合項目
			if(trueAry.indexOf(item.toLowerCase()) != -1)
				return true;
			
			//從錯誤陣列選找是否有符合項目
			if(falseAry.indexOf(item.toLowerCase()) != -1)
				return false;
				
			throw new Error("Indefinite Compare is failed.");
		}
	}
}

internal class SingletonEnforcer {
}