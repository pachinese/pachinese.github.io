/**

* @author DaYu

* @version 1.0.2

* @date created 2011/06/07

* @date updated 2013/11/28

* @project 華語文_筆順

*/

package calligraphy.btn
{    
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Timer;
	
	import dayu.display.BasicBtn;
	import dayu.events.BtnEvent;
	import dayu.events.GeneralEvent;
	import dayu.static.Singleton;
  
	public class VolumeBtn extends BasicBtn
	{
		//設定私域變數
		private var _singleton:Singleton;						//單一模式
		private var _sound:Sound;								//聲音
		private var _timer:Timer;								//計時器
		private var _mode:String;								//模式		
		
		//建構VolumeBtn
		public function VolumeBtn()
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
			_singleton.addEventListener(GeneralEvent.TOGGLE_STATUS, toogleStatusFn, false, 0, true);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteFn, false, 0, true);
			
			//上鎖
			lock();
		}
		
		//監聽從舞台移除(消滅)
		private function destroy(event:Event):void
		{			
			_singleton.removeEventListener(GeneralEvent.TOGGLE_STATUS, toogleStatusFn, false);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteFn, false);
		}
		
		//=======================↓設定監聽TimerEvent↓=======================//
		
		//監聽計時器完成
		private function timerCompleteFn(event:TimerEvent):void
		{
			this.click = false;
			this.mouseEnabled = true;
			
			_timer.reset();
			
			if(_mode == "List")
				return lock();
		}
		
		//=======================↑設定監聽TimerEvent↑=======================//
		//======================↓設定監聽GeneralEvent↓======================//
		
		//監聽觸發狀態事件
		private function toogleStatusFn(event:GeneralEvent):void
		{
			if(event.state != "List" && event.state != "Content")
				return;
			
			_mode = (event.state == "List" || event.state == "Content") ? event.state : _mode;
			
			if(_mode == "List")
				return lock();
				
			if(_mode == "Content")
				return unlock();
		}
		
		//======================↑設定監聽GeneralEvent↑======================//
		//========================↓覆寫BasicBtn功能↓========================//
		
		//監聽滑鼠點擊
		override protected function clickFn(event:MouseEvent):void
		{
			this.click = true;
			this.mouseEnabled = false;
			
			_singleton.dispatchEvent(new GeneralEvent(GeneralEvent.TOGGLE_STATUS, "Volume"));
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
		//=======================↓設定VolumeBtn 功能↓=======================//
		
		//上鎖
		public function lock():void
		{
			this.mouseEnabled = false;
			this.gotoAndStop(this.totalFrames);
		}
		
		//解鎖
		public function unlock():void
		{
			this.mouseEnabled = true;
			this.gotoAndStop(1);
		}
		
		//=======================↑設定VolumeBtn 功能↑=======================//
    }  
}