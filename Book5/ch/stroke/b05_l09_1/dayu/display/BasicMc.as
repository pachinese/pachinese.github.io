/**

* @author DaYu

* @version 1.0.1

* @date created 2011/06/01

*/

package dayu.display
{    
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class BasicMc extends MovieClip
	{
		//設定私域變數
		private var _dragMode:Boolean;								//拖移模式
		private var _originalX:Number;								//初始的X座標
		private var _originalY:Number;								//初始的Y座標
		
		//建構BasicMc
		public function BasicMc()
		{
			super();
			this.focusRect = false;
			this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
						
			//紀錄初始X、Y座標
			_originalX = this.x;
			_originalY = this.y;
		}
				
		//監聽加入舞台(初始化)
		private function init(event:Event):void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, dragFn, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_UP, dragFn, false, 0, true);
		}
		
		//監聽從舞台移除(消滅)
		private function destroy(event:Event):void
		{
			this.gotoAndStop(1);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, dragFn, false);
			this.removeEventListener(MouseEvent.MOUSE_UP, dragFn, false);
		}
		
		//========================↓設定BasicMc 參數↓========================//
		
		//設定是否啟用拖移模式
		public function set dragMode(dragMode:Boolean):void 
		{			
			_dragMode = dragMode;
		}
		
		//========================↑設定BasicMc 參數↑========================//
		//=========================↓監聽MouseEvent↓=========================//
		
		//監聽滑鼠拖移
		private function dragFn(event:MouseEvent):void
		{
			//檢查是否啟用拖移模式
			if(!_dragMode)
				return;
				
			if(event.type == MouseEvent.MOUSE_DOWN)
				this.startDrag();
			else
				this.stopDrag();
		}
		
		//=========================↑監聽MouseEvent↑=========================//
    }  
}