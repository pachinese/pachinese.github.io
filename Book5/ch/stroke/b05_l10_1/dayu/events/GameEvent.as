/**

* @author DaYu

* @version 1.0.1

* @date created 2011/05/03

*/

package dayu.events
{   
	import flash.events.Event;
	
	public class GameEvent extends Event  
	{
		//設定私域變數
		private var _state:String;										//自定事件參數state(狀態)
		private var _value:*;											//自定事件參數value(任意值)
				
		//設定全域GameEvent事件常數
		public static const NEW_GAME:String = "newGame";  				//新遊戲
		public static const LOAD_GAME:String = "loadGame";  			//讀取遊戲
		public static const SAVE_GAME:String = "saveGame";  			//儲存遊戲
		public static const EXIT_GAME:String = "exitGame";  			//離開遊戲
		public static const START_GAME:String = "startGame";  			//開始遊戲
		public static const PLAY_GAME:String = "playGame";  			//玩遊戲
		public static const PAUSE_GAME:String = "pauseGame";  			//暫停遊戲
		public static const REPLAY_GAME:String = "replayGame";			//重玩遊戲
		public static const BACK_GAME:String = "backGame";  			//返回遊戲
		
		//依照各遊戲不同附帶不同參數
		public static const TOGGLE_STATUS:String = "toggleStatus";  	//觸發狀態
		public static const TOGGLE_DEBUG:String = "toggleDebug";  		//觸發除錯
										
		//取得GameEvent自帶參數data
		public function get state():String { return _state; }
		public function get value():* { return _value; }
				
		//建構GameEvent函數
		public function GameEvent(type:String, state:String = null, value:* = null)
		{						
			//建構父類別(事件類型、可以反昇、無法取消)
			super(type, true, false);
			
			_state = state;
			_value = value;			
		}
 	}
}