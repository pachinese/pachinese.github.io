/**

* @author DaYu

* @version 1.0.2

* @date created 2011/04/24

*/

package dayu.net
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import dayu.events.LoaderEvent;
	import dayu.static.XmlEx;
	
	public class XmlLoader extends URLLoader
	{
		//設定私域變數
		private var _xml:XML;							//xml
		private var _content:Array;						//xml內容
		
		//建構XmlLoader
		public function XmlLoader(url:String = null)
		{
			/**
			
			* 檢查url是否為String且不為null
			
			* true:request為new URLRequest(url)
			
			* false:request為null
			
			*/
			
			var request:URLRequest = (url is String && url != null) ? new URLRequest(url) : null;
			super(request);
							
			init();
		}
		
		//取得xml內容
		public function get content():Array { return _content; }
		
		//讀取URL
		public function loadURL(url:String):void
		{
			super.load(new URLRequest(url));     
		}
		
		//初始化
		private function init():void
		{           
			_xml = new XML();
			_content = [];
			this.addEventListener(Event.COMPLETE, completeFn, false, 0, true);  
			this.addEventListener(ProgressEvent.PROGRESS, progressFn, false, 0, true);
			this.addEventListener(IOErrorEvent.IO_ERROR, ioErrorFn, false, 0, true);
		}
		
		//消滅
		public function destroy():void
		{
			_xml = null;
			_content = null;
			this.removeEventListener(Event.COMPLETE, completeFn, false);  
			this.removeEventListener(ProgressEvent.PROGRESS, progressFn, false);
			this.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorFn, false);
		}
		
		//監聽讀取完畢
		private function completeFn(event:Event): void
		{       
			_xml = XML(event.currentTarget.data);
			_content = XmlEx.toArray(_xml);
									
			this.dispatchEvent(new LoaderEvent(LoaderEvent.LOADER_COMPLETE));
        }
				
		//監聽讀取中
		private function progressFn(event:ProgressEvent):void
		{     
			var percentage:Number = Number(event.bytesLoaded / event.bytesTotal * 100);        
			this.dispatchEvent(new LoaderEvent(LoaderEvent.LOADER_PROGRESS, percentage));
		}
		
		//監聽讀取錯誤
		private function ioErrorFn(event:IOErrorEvent):void
		{
			this.dispatchEvent(new LoaderEvent(LoaderEvent.LOADER_ERROR));  
		}
	}
}