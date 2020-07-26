/**

* @author DaYu

* @version 1.0.1

* @date created 2011/05/03

*/

package dayu.events
{   
	import flash.events.Event;
	
	public class CtrlEvent extends Event  
	{
		//設定私域變數
		private var _state:String;			//自定事件參數state(狀態)
		private var _value:Number;			//自定事件參數value(任意值)
				
		//設定全域CtrlEvent事件常數
		public static const INFO_CHANGE:String = "infoChange";  			//資訊改變
		public static const STATE_CHANGE:String = "stateChange";  			//狀態改變
		public static const VOLUME_CHANGE:String = "volumeChange";  		//音量改變
		public static const SUBTITLE_CHANGE:String = "subtitleChange";		//字幕改變
		public static const MUSIC_CHANGE:String = "musicChange";  			//音樂改變
		public static const VISIBLE_CHANGE:String = "visibleChange";  		//可視性改變
		public static const ENABLED_CHANGE:String = "enabledChange";  		//可用性改變
						
		//取得CtrlEvent自帶參數data
		public function get state():String { return _state; }
		public function get value():Number { return _value; }
				
		//建構CtrlEvent函數
		public function CtrlEvent(type:String, state:String = undefined, value:Number = undefined)
		{						
			//建構父類別(事件類型、可以反昇、無法取消)
			super(type, true, false);
			
			_state = state;
			_value = value;			
		}
 	}
}