/**

* @author DaYu

* @version 1.0.2

* @date created 2011/06/07

* @date updated 2013/11/29

* @project 華語文_筆順

*/

package calligraphy.core
{    
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
		
	import dayu.events.GeneralEvent;
	import dayu.static.Singleton;
  
	public class SpeedLight extends MovieClip
	{
		//設定私域變數
		private var _singleton:Singleton;						//單一模式		
		private var _id:Number;									//識別id
		private var _speed:Number;								//速度		
				
		//建構SpeedLight
		public function SpeedLight()
		{
			super();
			this.stop();
			this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
						
			//初始化Singleton
			_singleton = Singleton.getInstance();
			
			//取得此Class名稱
			var name:String = getQualifiedClassName(this);
									
			//取得此id
			_id = parseInt(name.substring(name.lastIndexOf("_") + 1, name.length));
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
			if(event.state == "Speed")
				return changeSpeed(event.value);			
		}
		
		//======================↑設定監聽GeneralEvent↑======================//
		//=======================↓設定SpeedLight功能↓=======================//
		
		//改變速度
		private function changeSpeed(mode:String):void
		{
			if(mode == "Up" && _speed < 3)
				_speed++;
			
			if(mode == "Down" && _speed > 1)
				_speed--;
				
			if(mode == "Reset")
				_speed = 2;
			
			if(_id == _speed)
				this.gotoAndStop(2);
			else
				this.gotoAndStop(1);
		}
				
		//=======================↑設定SpeedLight功能↑=======================//
    }  
}