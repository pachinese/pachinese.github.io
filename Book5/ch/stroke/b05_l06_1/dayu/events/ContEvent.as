/**

* @author DaYu

* @version 1.0.1

* @date created 2011/05/03

*/

package dayu.events
{   
	import flash.events.Event;
	
	public class ContEvent extends Event  
	{	
		//設定全域ContEvent事件常數
		public static const CONT_INIT:String = "contInit";						//初始化
		public static const CONT_PLAYING:String = "contPlaying";				//正在播放
		public static const PROMPT_NEXT:String = "promrtNext";					//提示下一個

		//建構ContEvent函數
		public function ContEvent(type:String)
		{						
			//建構父類別(事件類型、可以反昇、無法取消)
			super(type, true, false);
		}
 	}
}