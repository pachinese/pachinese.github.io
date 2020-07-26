/**

* @author DaYu

* @version 1.0.1

* @date created 2011/05/03

*/

package dayu.events
{   
	import flash.events.Event;
	
	public class GeneralEvent extends Event  
	{
		//設定私域變數
		private var _state:String;			//自定事件參數state(狀態)
		private var _value:*;				//自定事件參數value(任意值)
		
		//設定全域GeneralEvent事件常數
		public static const TOGGLE_STATUS:String = "toggleStatus";  	//觸發狀態
		public static const TOGGLE_DEBUG:String = "toggleDebug";  		//觸發除錯
												
		//取得GeneralEvent自帶參數data
		public function get state():String { return _state; }
		public function get value():* { return _value; }
						
		//建構GeneralEvent函數
		public function GeneralEvent(type:String, state:String = undefined, ... arg)
		{						
			//建構父類別(事件類型、可以反昇、無法取消)
			super(type, true, false);
			
			_state = state;
			
			if(arg.length <= 1)
				_value = arg[0];
			else
				_value = arg;
		}
 	}
}