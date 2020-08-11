/**

* @author DaYu

* @version 1.0.1

* @date created 2010/11/11

*/

package dayu.display
{    
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	import dayu.display.BasicBtn;
	import dayu.events.BtnEvent;
  
	public class BasicClickBtn extends BasicBtn
	{
		//建構BasicClickBtn
		public function BasicClickBtn()
		{
			super();
		}
		
		//監聽滑鼠點擊
		override protected function clickFn(event:MouseEvent):void
		{
			this.dispatchEvent(new BtnEvent(BtnEvent.DO_CLICK, this.id));
		}
		
		//監聽設定完成
		override protected function setCompleteFn(event:BtnEvent):void
		{
			event.stopImmediatePropagation();
		
			trace(getQualifiedClassName(event.target) + " 設定完成。");
		}
    }  
}