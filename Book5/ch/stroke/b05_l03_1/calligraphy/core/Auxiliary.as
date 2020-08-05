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
	
	import caurina.transitions.properties.DisplayShortcuts;
	import caurina.transitions.Tweener;
	
	import dayu.events.GeneralEvent;
	import dayu.static.Singleton;
  
	public class Auxiliary extends MovieClip
	{
		//設定私域變數
		private var _singleton:Singleton;						//單一模式
				
		//建構Auxiliary
		public function Auxiliary()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			//初始化DisplayShortcuts
			DisplayShortcuts.init();
			
			//初始化Singleton
			_singleton = Singleton.getInstance();
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
			
			//移除Tweener
			Tweener.removeTweens(this);
		}
		
		//======================↓設定監聽GeneralEvent↓======================//
		
		//監聽觸發狀態事件
		private function toogleStatusFn(event:GeneralEvent):void
		{
			if(event.state == "Content")
				return this.show();
			
			if(event.state == "List")
				return this.hide();
			
			if(event.state == "Animation")
				return this.gotoAndStop(1);
			
			if(event.state == "Stroke")
				return this.gotoAndStop(2);
		}
		
		//======================↑設定監聽GeneralEvent↑======================//
		//=======================↓設定Auxiliary 功能↓=======================//
		
		//顯示
		private function show():void
		{
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
		private function hide():void
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
		
		//=======================↑設定Auxiliary 功能↑=======================//
    }  
}