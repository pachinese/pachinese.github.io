/**

* @author DaYu

* @version 1.0.1

* @date created 2010/11/19

*/

package dayu.static
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import caurina.transitions.Tweener;
	
	public class Message extends DisplayObject
	{
		//設定私域變數
		private var _stage:Stage;					//舞台
		private var _msg:Sprite;					//訊息
		
		//建構Message
		public function Message(singletonEnforcer:SingletonEnforcer)
		{
			if(! singletonEnforcer is SingletonEnforcer || singletonEnforcer == null)
			{
				throw new Error("Message can not create by New.");
			}
		}
		
		//顯示訊息(靜態)
		public static function show(stage:Stage, str:String):void
		{
			_stage = stage;
			
			_msg = new Sprite();
			_msg.name = "Msg";
			
			var bg:Shape = new Shape();
			
			bg.alpha = 0;
			bg.graphics.beginFill(0x000000, 1);
			bg.graphics.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
			bg.graphics.endFill();

			Tweener.addTween(bg, 
			{ 
				alpha: 0.75,
				time: 1,
				transition: "easeOutCubic"
			});
			
			_msg.addChild(bg);
						
			var frame:Shape = new Shape();
			
			frame.alpha = 0;
			frame.graphics.beginFill(0x999999, 1);
			frame.graphics.drawRoundRect(-300, -50, 600, 100, 15, 15);
			frame.graphics.endFill();
			frame.width = 40;
			frame.height = 10;
			frame.x = _stage.stageWidth / 2;
			frame.y = _stage.stageHeight / 2;
						
			Tweener.addTween(frame, 
			{ 
				height: 100,
				alpha: 0.5,
				time: 0.5,
				transition: "easeOutCubic"
			});
			
			Tweener.addTween(frame, 
			{ 
				width: 600,
				alpha: 0.7,
				delay: 0.5,
				time: 1,
				transition: "easeOutCubic",
				onComplete: function()
				{
					txt.visible = true;
					
					hide();
				}
			});
			
			_msg.addChild(frame);
			
			var txtFormat:TextFormat = new TextFormat();
			
			txtFormat.color = 0x000000;
			txtFormat.size = 16;
			
			var txt:TextField = new TextField();
			
			txt.autoSize = "center";
			txt.cacheAsBitmap = true;
			txt.selectable = false;
			txt.visible = false;
			txt.text = str;
			txt.x = _stage.stageWidth / 2 - txt.width / 2;
			txt.y = _stage.stageHeight / 2 - txt.height / 2;
			txt.setTextFormat(txtFormat);
			
			_msg.addChild(txt);

			_stage.addChild(_msg);
		}
		
		//隱藏訊息(靜態)
		public static function hide():void
		{
			_stage.removeChild(_msg);
		}
    }  
}

internal class SingletonEnforcer {
}