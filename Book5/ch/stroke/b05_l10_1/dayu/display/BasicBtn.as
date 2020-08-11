/**

* @author DaYu

* @version 1.0.5

* @date created 2011/06/01

*/

package dayu.display
{    
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
		
	import dayu.events.BtnEvent;
  
	public class BasicBtn extends MovieClip
	{
		//設定私域變數
		private var _set:Boolean;						//是否設定
		private var _id:Number;							//識別id
		private var _click:Boolean;						//點擊
		
		//取得/寫入id
		public function get id():Number { return _id; }
		public function set id(value:Number):void 
		{
			//檢查是否已設定
			if(_set)
				return;
			
			_set = true;
			_id = value; 
			this.dispatchEvent(new BtnEvent(BtnEvent.SET_COMPLETE, _id));
		}
		
		//取得/寫入click
		public function get click():Boolean { return _click; }
		public function set click(value:Boolean):void
		{
			_click = value;
			
			if(!_click)
				return this.gotoAndStop(1);
				
			if(_click)
				return this.gotoAndStop(3);
		}
				
		//建構BasicBtn
		public function BasicBtn()
		{
			super();
			this.stop();
			this.buttonMode = true;
			this.focusRect = false;
			this.mouseChildren = false;
			this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
		}
				
		//監聽加入舞台(初始化)
		private function init(event:Event):void
		{			
			this.addEventListener(MouseEvent.ROLL_OUT, rollFn, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OVER, rollFn, false, 0, true);
			this.addEventListener(MouseEvent.CLICK, clickFn, false, 0, true);
			this.addEventListener(BtnEvent.SET_COMPLETE, setCompleteFn, false, 0, true);
			
			//取得此Class名稱
			var name:String = getQualifiedClassName(this);
			
			//取得此Id
			var id:Number = parseInt(name.substring(name.lastIndexOf("_") + 1, name.length));
						
			//檢查格式是否正確
			if(isNaN(id))
				return;
					
			this.id = id;
		}
		
		//監聽從舞台移除(消滅)
		private function destroy(event:Event):void
		{			
			this.removeEventListener(MouseEvent.ROLL_OUT, rollFn, false);
			this.removeEventListener(MouseEvent.ROLL_OVER, rollFn, false);
			this.removeEventListener(MouseEvent.CLICK, clickFn, false);
			this.removeEventListener(BtnEvent.SET_COMPLETE, setCompleteFn, false);
		}
						
		//監聽滑鼠滑入/滑出
		protected function rollFn(event:MouseEvent):void
		{
			if(event.type == MouseEvent.ROLL_OUT && _click == false)
				return this.gotoAndStop(1);
			
			if(event.type == MouseEvent.ROLL_OUT && _click == true)
				return this.gotoAndStop(3);
		
			if(event.type == MouseEvent.ROLL_OVER && _click == false)
				return this.gotoAndStop(2);
				
			if(event.type == MouseEvent.ROLL_OVER && _click == true && this.totalFrames < 4)
				return this.gotoAndStop(2);
			
			if(event.type == MouseEvent.ROLL_OVER && _click == true && this.totalFrames >= 4)
				return this.gotoAndStop(4);
		}
		
		//監聽滑鼠點擊
		protected function clickFn(event:MouseEvent):void
		{
			trace("觸發點擊事件。");
		}
		
		//監聽設定完成
		protected function setCompleteFn(event:BtnEvent):void
		{			
			trace(getQualifiedClassName(event.target) + " 設定完成。", "id:" + _id);
		}
    }  
}