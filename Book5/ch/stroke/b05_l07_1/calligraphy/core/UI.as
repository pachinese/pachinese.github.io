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
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.Mouse;
	
	import caurina.transitions.Tweener;
	
	import dayu.display.AllLoader;
	import dayu.events.GeneralEvent;
	import dayu.events.LoaderEvent;
	import dayu.net.XmlLoader;
	import dayu.static.Singleton;
  
	public class UI extends Sprite
	{
		//設定私域變數
		private var _singleton:Singleton;						//單一模式
		private var _ldr:AllLoader;								//載入容器
		private var _xml:XmlLoader;								//xml容器
		private var _mode:String;								//模式
		private var _type:String;								//類型
		private var _sound:Sound;								//聲音
		private var _rightEffect:Sound;							//正確音效
		private var _wrongEffect:Sound;							//錯誤音效
		private var _rect:Rectangle;							//矩形
		private var _pen:*;										//筆
		private var _wordAry:Array;								//單字陣列
		private var _nowWord:Number;							//現在單字
		private var _allWord:Number;							//全部單字
		
		//建構UI
		public function UI()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			//初始化Singleton
			_singleton = Singleton.getInstance();
						
			//初始化載入容器
			_ldr = new AllLoader();
			_ldr.x = 300;
			_ldr.y = 80;
			
			this.cont_mc.addChild(_ldr);
			
			//初始化xml容器
			_xml = new XmlLoader();
			
			//初始化正確音效
			_rightEffect = new RightSound();
			
			//初始化錯誤音效
			_wrongEffect = new WrongSound();
			
			//初始化矩形
			_rect = new Rectangle(252, 65, 350, 285);
			
			//初始化筆
			_pen = new Item_Pen();
			_pen.visible = false;
						
			this.cont_mc.addChild(_pen);
		}
		
		//監聽加入舞台(初始化)
		private function init(event:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveFn, false, 0, true);
			
			_singleton.addEventListener(GeneralEvent.TOGGLE_STATUS, toogleStatusFn, false, 0, true);
			_ldr.addEventListener(LoaderEvent.LOADER_COMPLETE, ldrLoadCompleteFn, false, 0, true);
			_xml.addEventListener(LoaderEvent.LOADER_COMPLETE, xmlLoadCompleteFn, false, 0, true);
									
			_singleton.dispatchEvent(new GeneralEvent(GeneralEvent.TOGGLE_STATUS, "List"));
			_singleton.dispatchEvent(new GeneralEvent(GeneralEvent.TOGGLE_STATUS, "Animation"));
		}
		
		//監聽從舞台移除(消滅)
		private function destroy(event:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveFn, false);
			
			_singleton.removeEventListener(GeneralEvent.TOGGLE_STATUS, toogleStatusFn, false);
			_ldr.removeEventListener(LoaderEvent.LOADER_COMPLETE, ldrLoadCompleteFn, false);
			_xml.removeEventListener(LoaderEvent.LOADER_COMPLETE, xmlLoadCompleteFn, false);
			
			//移除Tweener
			Tweener.removeTweens(this);
		}
		
		//=======================↓設定監聽MouseEvent↓=======================//
		
		//監聽滑鼠移動事件
		private function mouseMoveFn(event:MouseEvent):void
		{
			if(_mode != "Content" || _type != "Stroke")
				return;
			
			_pen.x = mouseX;
			_pen.y = mouseY;
						
			if(_rect.containsPoint(new Point(_pen.x, _pen.y)))
				showPen();
			else
				hidePen();
		}
				
		//=======================↑設定監聽MouseEvent↑=======================//		
		//======================↓設定監聽GeneralEvent↓======================//
		
		//監聽觸發狀態事件
		private function toogleStatusFn(event:GeneralEvent):void
		{
			_mode = (event.state == "List" || event.state == "Content") ? event.state : _mode;
			_type = (event.state == "Animation" || event.state == "Stroke") ? event.state: _type;
			
			if(event.state == "List")
				return initList();
				
			if(event.state == "Content")
				return initContent(event.value);
			
			if((event.state == "Animation" || event.state == "Stroke") && _mode == "Content")					
				return initWord();
							
			if(event.state == "Cross" && event.value == "Next" && _mode == "Content")
				return nextWord();
				
			if(event.state == "Cross" && event.value == "Prev" && _mode == "Content")
				return prevWord();
				
			if(event.state == "Volume" && _mode == "Content")
				return playVolume();
				
			if(event.state == "SoundEffect")
				return playSoundEffect(event.value);
		}
		
		//======================↑設定監聽GeneralEvent↑======================//
		//======================↓設定監聽LoaderEvent ↓======================//
		
		//監聽內容讀取解析完畢
		private function ldrLoadCompleteFn(event:LoaderEvent):void
		{			
			//觸發連結(連結目標)
			_singleton.dispatchEvent(new GeneralEvent(GeneralEvent.TOGGLE_STATUS, "Link", _wordAry[_nowWord - 1].link));
						
			//觸發速度(重新設定)
			_singleton.dispatchEvent(new GeneralEvent(GeneralEvent.TOGGLE_STATUS, "Speed", "Reset"));
			
			//觸發自動提示(隱藏)
			_singleton.dispatchEvent(new GeneralEvent(GeneralEvent.TOGGLE_STATUS, "AutoTips", "Hide"));
			
			//移除Tweener
			Tweener.removeTweens(this);
			
			//加入Tweener
			Tweener.addTween(this, 
			{ 
				time		: 1,
				transition	: "linear",
				onComplete	: function() { if(_sound) _sound.play(); }
			});
		}
		
		//監聽XML讀取解析完畢
		private function xmlLoadCompleteFn(event:LoaderEvent):void
		{
			_wordAry = _xml.content;
			
			_nowWord = 1;
			_allWord = _wordAry.length;
			
			//初始化單字
			initWord();
		}
		
		//======================↑設定監聽LoaderEvent ↑======================//
		//===========================↓設定UI功能↓===========================//
		
		//初始化清單
		private function initList():void
		{
			_ldr.unload();
			_sound = null;
			_wordAry = [];
			
			hidePen();
		}
		
		//初始化內容
		private function initContent(value:String):void
		{
			var link:String = value;
			
			//載入xml
			_xml.loadURL(link);
		}
		
		//初始化單字
		private function initWord():void
		{
			var link:String = (_type == "Animation") ? _wordAry[_nowWord - 1].animation : _wordAry[_nowWord - 1].stroke;
			
			trace(_type, link);
			
			//載入swf
			_ldr.loadURL(link);
			
			//建立聲音
			_sound = new Sound(new URLRequest(_wordAry[_nowWord - 1].sound));
		}
				
		//下一單字
		private function nextWord():void
		{
			if(_nowWord == _allWord)
				return;
			
			_nowWord++;
			
			//初始化單字
			initWord();
		}
		
		//上一單字
		private function prevWord():void
		{
			if(_nowWord == 1)
				return;
				
			_nowWord--;
			
			//初始化單字
			initWord();
		}
		
		//顯示畫筆
		private function showPen():void
		{
			_pen.visible = true;
			
			//隱藏滑鼠
			Mouse.hide();
		}
		
		//影藏畫筆
		private function hidePen():void
		{
			_pen.visible = false;
			
			//顯示滑鼠
			Mouse.show();
		}
		
		//播放語音
		private function playVolume():void
		{			
			if(_sound) _sound.play();
		}
		
		//播放音效
		private function playSoundEffect(value:String):void
		{
			if(value == "Right")
				_rightEffect.play();
				
			if(value == "Wrong")
				_wrongEffect.play();
		}
		
		//===========================↑設定UI功能↑===========================//
    }  
}