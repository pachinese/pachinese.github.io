/**

* @author DaYu

* @version 1.0.0

* @date created 2010/06/11

*/

package dayu.display
{    
	import flash.display.Loader;  
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import dayu.events.LoaderEvent;
  
	public class AllLoader extends Loader
	{
		//建構AllLoader
		public function AllLoader()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
		}
		
		//讀取URL
		public function loadURL(url:String, context:LoaderContext = null):void
		{
			super.unload();
			super.load(new URLRequest(url), context);     
		}
		
		//監聽加入舞台(初始化)
		private function init(event:Event):void
		{           
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, completeFn, false, 0, true);  
			this.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressFn, false, 0, true);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorFn, false, 0, true);
		}
		
		//監聽從舞台移除(消滅)
		private function destroy(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init, false);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy, false);
			this.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeFn, false);  
			this.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressFn, false);
			this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorFn, false);
		}
		
		//監聽讀取完畢
		private function completeFn(event:Event): void
		{       
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