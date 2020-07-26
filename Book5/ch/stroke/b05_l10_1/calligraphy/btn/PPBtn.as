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
	
	import caurina.transitions.properties.DisplayShortcuts;
	import caurina.transitions.Tweener;
	
	import dayu.display.BasicBtn;
	import dayu.events.BtnEvent;
	import dayu.events.GeneralEvent;
	import dayu.static.Singleton;
  
	public class PPBtn extends BasicBtn
	{
		//設定私域變數
		private var _singleton:Singleton;						//單一模式
		private var _sound:Sound;								//聲音
		private var _timer:Timer;								//計時器
		private var _mode:String;								//模式
		private var _type:String;								//類型
		
		//建構PPBtn
		public function PPBtn()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			//初始化DisplayShortcuts
			DisplayShortcuts.init();
			
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
		}
		
		//監聽從舞台移除(消滅)
		private function destroy(event:Event):void
		{
			_singleton.removeEventListener(GeneralEvent.TOGGLE_STATUS, toogleStatusFn, false);
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteFn, false);
			
			//移除Tweener
			Tweener.removeTweens(this);
		}
		
		//=======================↓設定監聽TimerEvent↓=======================//
		
		//監聽計時器完成
		private function timerCompleteFn(event:TimerEvent):void
		{
			this.click = !this.click;
			this.mouseEnabled = true;
			
			_singleton.dispatchEvent(new GeneralEvent(GeneralEvent.TOGGLE_STATUS, "Cross", "None"));
			_timer.reset();
		}
		
		//=======================↑設定監聽TimerEvent↑=======================//
		//======================↓設定監聽GeneralEvent↓======================//
		
		//監聽觸發狀態事件
		private function toogleStatusFn(event:GeneralEvent):void
		{
			if(event.state == "Cross" && (event.value == "Replay" || event.value == "Prev" || event.value == "Next"))
			{
				this.click = false;
				this.mouseEnabled = true;
				
				_timer.reset();
				
				return;
			}
			
			if(event.state != "List" && event.state != "Content" && event.state != "Animation" && event.state != "Stroke")
				return;
			
			_mode = (event.state == "List" || event.state == "Content") ? event.state : _mode;
			_type = (event.state == "Animation" || event.state == "Stroke") ? event.state: _type;
						
			if(_mode == "List" || _type == "Stroke")
				return this.hide();
				
			if(_mode == "Content" && _type == "Animation")
				return this.show();
		}
		
		//======================↑設定監聽GeneralEvent↑======================//
		//========================↓覆寫BasicBtn功能↓========================//
		
		//監聽滑鼠點擊
		override protected function clickFn(event:MouseEvent):void
		{
			this.mouseEnabled = false;
			
			if(!this.click)
				_singleton.dispatchEvent(new GeneralEvent(GeneralEvent.TOGGLE_STATUS, "Cross", "Pause"));
			else
				_singleton.dispatchEvent(new GeneralEvent(GeneralEvent.TOGGLE_STATUS, "Cross", "Play"));
				
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
		//=======================↓設定CheckerBtn功能↓=======================//
		
		//顯示
		public function show():void
		{
			this.click = false;
			
			//移除Tweener
			Tweener.removeTweens(this);
			
			//加入Tweener
			Tweener.addTween(this, 
			{ 
				_autoAlpha	: 1,
				time		: 0.5,
				transition	: "easeOutCubic"
			});
		}
		
		//隱藏
		public function hide():void
		{			
			//移除Tweener
			Tweener.removeTweens(this);
			
			//加入Tweener
			Tweener.addTween(this, 
			{ 
				_autoAlpha	: 0,
				time		: 0.5,
				transition	: "easeOutCubic"
			});
		}
		
		//=======================↑設定CheckerBtn功能↑=======================//
    }  
}