/**

* @author DaYu

* @version 1.0.2

* @date created 2011/06/07

* @date updated 2013/11/29

* @project 華語文_筆順

*/

package calligraphy.btn
{    
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.Dictionary;
		
	import dayu.events.GeneralEvent;
	import dayu.static.Singleton;
  
	public class CrossBtn extends MovieClip
	{
		//設定私域變數
		private var _singleton:Singleton;						//單一模式
		private var _dict:Dictionary;							//集合
				
		//建構CrossBtn
		public function CrossBtn()
		{
			super();
			this.stop();
			this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			//初始化Singleton
			_singleton = Singleton.getInstance();
			
			//初始化集合
			_dict = new Dictionary();
			_dict["None"] = "Normal";
			_dict["Play"] = "Up";
			_dict["Pause"] = "Up";
			_dict["Next"] = "Right";
			_dict["Replay"] = "Down";
			_dict["Clear"] = "Down";
			_dict["Prev"] = "Left";
		}
		
		//監聽加入舞台(初始化)
		private function init(event:Event):void
		{			
			_singleton.addEventListener(GeneralEvent.TOGGLE_STATUS, toogleStatusFn, false, 0, true);
		}
		
		//監聽從舞台移除(消滅)
		private function destroy(event:Event):void
		{			
			_singleton.removeEventListener(GeneralEvent.TOGGLE_STATUS, toogleStatusFn, false);
		}
		
		//======================↓設定監聽GeneralEvent↓======================//
		
		//監聽觸發狀態事件
		private function toogleStatusFn(event:GeneralEvent):void
		{
			if(event.state != "Cross")
				return;
			
			this.gotoAndStop(_dict[event.value]);
		}
		
		//======================↑設定監聽GeneralEvent↑======================//
    }  
}