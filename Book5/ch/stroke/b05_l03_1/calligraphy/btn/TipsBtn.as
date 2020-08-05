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
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.media.Sound;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Timer;
	
	import dayu.display.BasicBtn;
	import dayu.events.BtnEvent;
	import dayu.events.GeneralEvent;
	import dayu.static.Singleton;
  
	public class TipsBtn extends BasicBtn
	{
		//設定私域變數
		private var _singleton:Singleton;						//單一模式
		private var _sound:Sound;								//聲音
		private var _timer:Timer;								//計時器
		
		//建構TipsBtn
		public function TipsBtn()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			//初始化Singleton
			_singleton = Singleton.getInstance();
			
			//初始化聲音
			_sound = new ClickSound();
			
			//初始化計時器
			_timer = new Timer(100, 1);
		}
		
		//監聽加入舞台(初始化)
		private function init(event:Event):void
		{			
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteFn, false, 0, true);
		}
		
		//監聽從舞台移除(消滅)
		private function destroy(event:Event):void
		{			
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteFn, false);
		}
		
		//=======================↓設定監聽TimerEvent↓=======================//
		
		//監聽計時器完成
		private function timerCompleteFn(event:TimerEvent):void
		{
			this.click = false;
			this.mouseEnabled = true;
			
			_timer.reset();
		}
		
		//=======================↑設定監聽TimerEvent↑=======================//
		//========================↓覆寫BasicBtn功能↓========================//
		
		//監聽滑鼠點擊
		override protected function clickFn(event:MouseEvent):void
		{
			this.click = true;
			this.mouseEnabled = false;
			
			_singleton.dispatchEvent(new GeneralEvent(GeneralEvent.TOGGLE_STATUS, "Tips"));
			_sound.play();
			_timer.start();
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