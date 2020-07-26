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
	
	import dayu.display.BasicBtn;
	import dayu.events.BtnEvent;
  
	public class BasicChangeBtn extends BasicBtn
	{
		//建構BasicChangeBtn
		public function BasicChangeBtn()
		{
			super();
		}
		
		//監聽滑鼠點擊
		override protected function clickFn(event:MouseEvent):void
		{
			this.dispatchEvent(new BtnEvent(BtnEvent.DO_CHANGE, this.id));
		}
    }  
}