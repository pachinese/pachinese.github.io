/**

* @author DaYu

* @version 1.0.3

* @date created 2011/05/30

*/

package dayu.events
{   
	import flash.events.Event;
	
	public class BtnEvent extends Event  
	{
		//設定私域變數
		private var _id:Number;			//自定事件參數id(識別id)
		
		//設定全域BtnEvent事件常數
		public static const SET_COMPLETE:String = "setComplete";  		//設定完畢
		public static const DO_CHANGE:String = "doChange";				//變更
		public static const DO_CLICK:String = "doClick";				//點擊
		public static const DO_OPEN:String = "doOpen";					//開啟
		public static const DO_CLOSE:String = "doClose";				//關閉
				
		//取得BtnEvent自帶參數id(識別id)
		public function get id():Number { return _id; }
		
		//建構BtnEvent函數
		public function BtnEvent(type:String , id:Number = 0)
		{
			//建構父類別(事件類型、可以反昇、無法取消)
			super(type, true, false);
			
			_id = id;
		}
 	}
}
