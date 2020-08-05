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
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	import dayu.display.BasicBtn;
	import dayu.events.BtnEvent;
	import dayu.events.GeneralEvent;
	import dayu.static.Singleton;
  
	public class AnimationBtn extends BasicBtn
	{
		//設定私域變數
		private var _singleton:Singleton;						//單一模式
		private var _sound:Sound;								//聲音
				
		//建構AnimationBtn
		public function AnimationBtn()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			//初始化Singleton
			_singleton = Singleton.getInstance();
			
			//初始化聲音
			_sound = new ClickSound();
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
			if(event.state == "Animation")
				this.click = true;
			
			if(event.state == "Stroke")
				this.click = false;
				
			this.mouseEnabled = !this.click;
		}
		
		//======================↑設定監聽GeneralEvent↑======================//
		//========================↓覆寫BasicBtn功能↓========================//
		
		//監聽滑鼠點擊
		override protected function clickFn(event:MouseEvent):void
		{						
			_singleton.dispatchEvent(new GeneralEvent(GeneralEvent.TOGGLE_STATUS, "Animation"));
			_sound.play();
		}
		
		//監聽設定完成
		override protected function setCompleteFn(event:BtnEvent):void
		{
			event.stopImmediatePropagation();
		
			trace(getQualifiedClassName(event.target) + " 設定完成。");
		}
		
		//========================↑覆寫BasicBtn功能↑========================//
    }  
}