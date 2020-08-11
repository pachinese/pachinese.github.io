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
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
		
	import dayu.display.BasicBtn;
	import dayu.events.BtnEvent;
	import dayu.events.GeneralEvent;
	import dayu.static.Singleton;
  
	public class ContentBtn extends BasicBtn
	{
		//設定私域變數
		private var _singleton:Singleton;						//單一模式
		private var _sound:Sound;								//聲音
		private var _chinese:String;							//中文
		private var _pinyin:String;								//拼音
		private var _link:String;								//連結		
		
		//取得/寫入chinese
		public function get chinese():String { return _chinese; }
		public function set chinese(value:String):void 
		{			
			_chinese = value; 
			this.chinese_txt.text = _chinese;
			this.chinese_txt.cacheAsBitmap = true;
		}
		
		
		//取得/寫入pinyin
		public function get pinyin():String { return _pinyin; }
		public function set pinyin(value:String):void 
		{
			_pinyin = value; 
			this.pinyin_txt.text = _pinyin;
			this.pinyin_txt.cacheAsBitmap = true;
		}
		
		//取得/寫入link
		public function get link():String { return _link; }
		public function set link(value:String):void { _link = value; }
				
		//建構ContentBtn
		public function ContentBtn()
		{
			super();
						
			//初始化Singleton
			_singleton = Singleton.getInstance();
			
			//初始化聲音
			_sound = new ClickSound();
		}
		
		//========================↓覆寫BasicBtn功能↓========================//
		
		//監聽滑鼠點擊
		override protected function clickFn(event:MouseEvent):void
		{
			_singleton.dispatchEvent(new GeneralEvent(GeneralEvent.TOGGLE_STATUS, "Content", _link));
			_sound.play();
		}
		
		//監聽設定完成
		override protected function setCompleteFn(event:BtnEvent):void
		{
			event.stopImmediatePropagation();
		
			trace(getQualifiedClassName(event.target) + " 設定完成。");
		}
		
		//========================↑覆寫BasicBtn功能↑========================//
    }  
}