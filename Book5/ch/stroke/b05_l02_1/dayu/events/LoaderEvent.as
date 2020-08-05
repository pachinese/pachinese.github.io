/**

* @author DaYu

* @version 1.0.1

* @date created 2011/05/03

*/

package dayu.events
{   
	import flash.events.Event;
	
	public class LoaderEvent extends Event  
	{
		//設定私域變數
		private var _value:*;			//自定事件參數value(任意值)
		
		//設定全域LoaderEvent事件常數
		public static const LOADER_INIT:String = "loaderInit";  			//讀取初始化
		public static const LOADER_COMPLETE:String = "loaderComplete";  	//讀取完畢
		public static const LOADER_PROGRESS:String = "loaderProgress";  	//讀取中
		public static const LOADER_ERROR:String = "loaderError";  			//讀取錯誤
				
		//取得LoaderEvent自帶參數(連結, 進度百分比)
		public function get value():* { return _value; }
		
		//建構LoaderEvent函數
		public function LoaderEvent(type:String, value:* = undefined)
		{
			//建構父類別(事件類型、可以反昇、無法取消)
			super(type, true, false);
			
			_value = value;
		}
 	}
}
