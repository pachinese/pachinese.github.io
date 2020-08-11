/**

* @author DaYu

* @version 1.0.0

* @date created 2011/06/13

*/

package dayu.effects
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import caurina.transitions.Tweener;	

	public class GrowBounce extends Sprite
	{
		//設定私域變數
		private var _mode:String;							//模式
		
		public function GrowBounce()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
									
			//取得此Class名稱
			var name:String = getQualifiedClassName(this);
			
			//取得此模式
			var mode:String = name.substring(name.lastIndexOf("_") + 1, name.length);
			
			if(!(mode == "Show" || mode == "Hide"))
				return;
			
			_mode = mode;
		}
		
		//監聽加入舞台(初始化)
		private function init(event:Event):void
		{
			if(_mode == "Show")
				return show(this);
				
			if(_mode == "Hide")
				return hide(this);
		}
		
		//監聽從舞台移除(消滅)
		private function destroy(event:Event):void
		{
			//移除Tweener
			Tweener.removeTweens(this);
		}		
		
		//顯示
		public static function show(target:Object, time:Number = 1, delay:Number = 0):void
		{
			target.defaultHeight = target.height;
			target.defaultY = target.y;
			target.height = 0;
			
			Tweener.addTween(target,
			{
				height: target.defaultHeight,
				time: time,
				delay: delay,
				transition: "easeOutBounce",
				onUpdate: function()
				{
					this.y = target.defaultY + target.defaultHeight - this.height;
				}
			});
		}
		
		//隱藏
		public static function hide(target:Object, time:Number = 1, delay:Number = 0):void
		{
			target.defaultHeight = target.height;
			target.defaultY = target.y;
						
			Tweener.addTween(target,
			{
				height: 0,
				time: time,
				delay: delay,
				transition: "easeOutBounce",
				onUpdate: function()
				{
					this.y = target.defaultY + target.defaultHeight - this.height;
				}
			});
		}
	}
}