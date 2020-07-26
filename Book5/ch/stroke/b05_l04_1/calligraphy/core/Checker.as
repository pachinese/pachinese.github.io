/**

* @author DaYu

* @version 1.0.2

* @date created 2011/06/07

* @date updated 2013/11/29

* @project 華語文_筆順

*/

package calligraphy.core
{    
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	import caurina.transitions.Tweener;
	
	import dayu.events.GeneralEvent;
	import dayu.static.Singleton;
  
	public class Checker extends Sprite
	{
		//設定私域變數
		private var _singleton:Singleton;						//單一模式
				
		//建構Checker
		public function Checker()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
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
			
			if(event.state != "Checker")
				return;
			
			if(event.value == "show")
				return this.show();
				
			if(event.value == "hide")
				return this.hide();
		}
		
		//======================↑設定監聽GeneralEvent↑======================//
		//========================↓設定Checker 功能↓========================//
		
		//顯示
		private function show():void
		{
			//移除Tweener
			Tweener.removeTweens(this);
			
			//加入Tweener
			Tweener.addTween(this, 
			{ 
				alpha		: 1,
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
				alpha		: 0,
				time		: 0.5,
				transition	: "easeOutCubic"
			});
		}
		
		//========================↑設定Checker 功能↑========================//
    }  
}