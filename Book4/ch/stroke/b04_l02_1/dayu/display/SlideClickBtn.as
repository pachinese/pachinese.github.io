/**

* @author DaYu

* @version 1.0.1

* @date created 2010/11/19

*/

package dayu.display
{    
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import dayu.display.BasicBtn;
	import dayu.events.BtnEvent;
  
	public class SlideClickBtn extends BasicBtn
	{
		//建構SlideClickBtn
		public function SlideClickBtn()
		{
			super();
		}
		
		//監聽滑鼠滑入/滑出
		override protected function rollFn(event:MouseEvent):void
		{
			if(event.type == MouseEvent.ROLL_OUT)
			{				
				if(!this.isClick)
					this.gotoAndStop(1);
				else
					this.gotoAndStop(3);
					
				this.dispatchEvent(new BtnEvent(BtnEvent.DO_CLICK, 0));
			}
			else
			{
				this.isClick = true;
				this.gotoAndStop(2);
				this.dispatchEvent(new BtnEvent(BtnEvent.DO_CLICK, this.id));
			}
		}
    }  
}