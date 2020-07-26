/**

* @author DaYu

* @version 1.0.2

* @date created 2011/06/15

*/

package dayu.static
{
	public class ArrayEx extends Object
	{
		//建構ArrayEx
		public function ArrayEx(singletonEnforcer:SingletonEnforcer)
		{
			if(! singletonEnforcer is SingletonEnforcer || singletonEnforcer == null)
			{
				throw new Error("ArrayEx can not create by New.");
			}
		}
		
		//亂數排序
		public static function randomSort(ary:Array):Array
		{
			var randomId:Number = 0;
			var oldAry:Array = ary.concat();
			var newAry:Array = [];
						
			while(oldAry.length)
			{
				//取得亂數索引
				randomId = Math.floor(Math.random() * oldAry.length)
				
				//將從舊陣列亂數取得的元素加入新陣列
				newAry.push(oldAry[randomId]);
				
				//刪除舊陣列原有的元素
				oldAry.splice(randomId, 1);  
			}
			
			return newAry;
		}
		
		//亂數選取
		public static function randomSelect(ary:Array, num:Number = 1, re:Boolean = false):Array
		{
			var randomId:Number = 0;
			var oldAry:Array = ary.concat();
			var newAry:Array = [];
						
			for(var id:Number = 0 ; id < num ; id++)
			{
				//取得亂數索引
				randomId = Math.floor(Math.random() * oldAry.length)
				
				//將從舊陣列亂數取得的元素加入新陣列
				newAry.push(oldAry[randomId]);
				
				//是否重複
				if(re)
					continue;
				
				//刪除舊陣列原有的元素
				oldAry.splice(randomId, 1);
			}
			
			return newAry;
		}
	}
}

internal class SingletonEnforcer {
}