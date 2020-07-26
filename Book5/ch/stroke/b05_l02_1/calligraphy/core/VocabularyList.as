/**

* @author DaYu

* @version 1.0.6

* @date created 2011/06/07

* @date updated 2013/11/29

* @project 華語文_筆順

*/

package calligraphy.core
{    
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import caurina.transitions.Tweener;
	
	import dayu.events.GeneralEvent;
	import dayu.events.LoaderEvent;
	import dayu.net.XmlLoader;
	import dayu.static.Common;
	import dayu.static.Singleton;
  
	public class VocabularyList extends MovieClip
	{
		//設定私域變數
		private var _singleton:Singleton;						//單一模式
		private var _xml:XmlLoader;								//xml容器
		private var _dict:Dictionary;							//集合
		private var _cont:Sprite;								//內容
		private var _mask:Sprite;								//遮罩
		private var _mode:String;								//模式
		private var _btnAry:Array;								//按鈕陣列
		private var _pageWidth:Number;							//頁面寬度
		private var _nowPage:Number;							//現在頁數
		private var _allPage:Number;							//全部頁數
		private var _ini:URLLoader;								//設定
						
		//建構VocabularyList
		public function VocabularyList()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			//初始化Singleton
			_singleton = Singleton.getInstance();
						
			//初始化xml
			_xml = new XmlLoader();
			
			//初始化集合
			_dict = new Dictionary();
			_dict[0] = new Point(184, 156);
			_dict[1] = new Point(24, 43);
			_dict[2] = new Point(184, 43);
			_dict[3] = new Point(24, 156);
			
			//初始化遮罩
			_mask = new Sprite();
			_mask.graphics.beginFill(0xFFFFFF);
			_mask.graphics.drawRect(0, 0, 352, 285);
 			_mask.graphics.endFill();
			
			this.addChild(_mask);
			
			//初始化內容
			_cont = new Sprite();
			_cont.mask = _mask;
			
			this.addChild(_cont);
			
			//初始化按鈕陣列
			_btnAry = [];
			
			//初始化頁面寬度
			_pageWidth = 352;
			
			//初始化設定
			_ini = new URLLoader();
			_ini.dataFormat = URLLoaderDataFormat.VARIABLES;
		}
		
		//監聽加入舞台(初始化)
		private function init(event:Event):void
		{			
			_singleton.addEventListener(GeneralEvent.TOGGLE_STATUS, toogleStatusFn, false, 0, true);
			_xml.addEventListener(LoaderEvent.LOADER_COMPLETE, xmlLoadCompleteFn, false, 0, true);
			_ini.addEventListener(Event.COMPLETE, completeFn, false, 0, true);
						
			//載入設定
			_ini.load(new URLRequest("setting.ini"));
		}
		
		//監聽從舞台移除(消滅)
		private function destroy(event:Event):void
		{			
			_singleton.removeEventListener(GeneralEvent.TOGGLE_STATUS, toogleStatusFn, false);
			_xml.removeEventListener(LoaderEvent.LOADER_COMPLETE, xmlLoadCompleteFn, false);
			_ini.addEventListener(Event.COMPLETE, completeFn, false);
		}
		
		//監聽完成
		private function completeFn(event:Event):void
		{		
			var book:String = (stage.loaderInfo.parameters.book != undefined) ? Common.tensToString(parseInt(stage.loaderInfo.parameters.book)) : Common.tensToString(parseInt(_ini.data.book));
			var lesson:String = (stage.loaderInfo.parameters.lesson != undefined) ? Common.tensToString(parseInt(stage.loaderInfo.parameters.lesson)) : Common.tensToString(parseInt(_ini.data.lesson));
								
			_xml.loadURL("data/b" + book + "_l" + lesson + ".xml");
			
			this.title_txt.text = (stage.loaderInfo.parameters.title != undefined) ? stage.loaderInfo.parameters.title : _ini.data.title;
		}
		
		//======================↓設定監聽LoaderEvent ↓======================//
		
		//監聽XML讀取解析完畢
		private function xmlLoadCompleteFn(event:LoaderEvent):void
		{
			var list:Array = _xml.content;
			var id:Number;
			var num:Number = list.length;
			var count:Number = 1;
			var obj:Object;
			var objClass:Class;
			var objPoint:Point = new Point();
						
			for(id = 1 ; id <= num ; id++)
			{
				obj = list[id - 1];
				objClass = (obj.chinese.length > 3) ? Btn_Content_L as Class: Btn_Content_S as Class;
				objPoint.x = _dict[count % 4].x + (_pageWidth * (Math.ceil(count / 4) - 1));
				objPoint.y = _dict[count % 4].y;
				
				addBtn(obj, objClass, objPoint);
				
				if(id != num)
					count = (obj.chinese.length > 3) ? count + 2 : count + 1;
			}
			
			_nowPage = 1;
			_allPage = Math.ceil(count / 4);
		}
		
		//======================↑設定監聽LoaderEvent ↑======================//
		//======================↓設定監聽GeneralEvent↓======================//
		
		//監聽觸發狀態事件
		private function toogleStatusFn(event:GeneralEvent):void
		{
			if(event.state == "List")
			{
				_mode = event.state;
				return showBtn();
			}
				
			if(event.state == "Content")
			{
				_mode = event.state;
				return hideBtn();
			}
			
			if(event.state == "Cross" && event.value == "Next" && _mode == "List")
				return nextPage();
				
			if(event.state == "Cross" && event.value == "Prev" && _mode == "List")
				return prePage();
		}
		
		//======================↑設定監聽GeneralEvent↑======================//
		//=====================↓設定VocabularyList功能↓=====================//
		
		//加入Btn
		private function addBtn(obj:Object, objClass:Class, objPoint:Point):void
		{
			var btn:* = new objClass()
						
			btn.chinese = obj.chinese;
			btn.pinyin = obj.pinyin;
			btn.link = obj.link;
			btn.x = objPoint.x;
			btn.y = objPoint.y;
			
			_cont.addChild(btn);
			
			_btnAry.push(btn);
		}
		
		//移除Btn
		private function removeBtn():void
		{
			if(_btnAry.length == 0)
				return;
				
			for each(var btn in _btnAry)
			{
				_cont.removeChild(btn);
			}
			
			_btnAry = [];
		}
				
		//顯示Btn
		private function showBtn():void
		{
			_cont.visible = true;
						
			Tweener.addTween(_cont, 
			{ 
				alpha: 1,
				time: 0.5,
				transition: "easeOutCubic"
			});
		}
		
		//隱藏Btn
		private function hideBtn():void
		{
			_cont.alpha = 0;
			_cont.visible = false;
		}
				
		//下一頁
		private function nextPage():void
		{
			if(_nowPage == _allPage)
				return;
			
			_nowPage++;
			
			Tweener.addTween(_cont, 
			{ 
				x: _cont.x - _pageWidth,
				time: 0.5,
				transition: "easeOutCubic"
			});
		}
		
		//上一頁
		private function prePage():void
		{
			if(_nowPage == 1)
				return;
				
			_nowPage--;
						
			Tweener.addTween(_cont, 
			{ 
				x: _cont.x + _pageWidth,
				time: 0.5,
				transition: "easeOutCubic"
			});
		}
		
		//=====================↑設定VocabularyList功能↑=====================//
    }  
}