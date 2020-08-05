/**

* @author DaYu

* @version 1.0.3

* @date created 2011/06/07

* @date updated 2014/01/07

* @project 華語文_筆順

*/

package calligraphy.core
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import caurina.transitions.Tweener;
	
	import dayu.events.GeneralEvent;
	import dayu.events.LoaderEvent;
	import dayu.net.XmlLoader;
	import dayu.static.Singleton;
  
	public class Animation extends MovieClip
	{
		//設定私域變數
		private var _link:String;									//連結
		private var _speed:Number;									//速度
		private var _easeDict:Dictionary;							//效果集合
		private var _ellipseArg:Number;								//橢圓參數
		private var _sizeArg:Number;								//大小參數
		
		//設定保護變數
		protected var _singleton:Singleton;							//單一模式
		protected var _xml:XmlLoader;								//xml容器
		protected var _nowDirection:Number;							//現在方向
		protected var _nowStroke:MovieClip;							//現在筆劃
		protected var _nowMask:Sprite;								//現在遮罩
		protected var _strokeAry:Array;								//筆劃陣列
		protected var _nowStrokeId:Number;							//現在筆劃id
		protected var _allStrokeNum:Number;							//全部筆劃數
		protected var _nowSubStrokeId:Number;						//現在次筆劃id
		protected var _allSubStrokeNum:Number;						//全部次筆劃數
				
		//取得/寫入link
		public function get link():String { return _link; }
		public function set link(value:String):void 
		{ 
			_link = value;
			
			//載入xml
			_xml.loadURL(_link);
		}
		
		//建構Animation
		public function Animation()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			//初始化Singleton
			_singleton = Singleton.getInstance();
			
			//初始化xml容器
			_xml = new XmlLoader();
						
			//初始化特效集合
			_easeDict = new Dictionary();
			_easeDict[0] = "easeOutCirc";
			_easeDict[1] = "easeInSine";
			
			//初始化橢圓參數
			_ellipseArg = 50;
			
			//初始化大小參數
			_sizeArg = 260;
			
			//初始化速度
			_speed = 2;
		}
		
		//監聽加入舞台(初始化)
		private function init(event:Event):void
		{			
			_singleton.addEventListener(GeneralEvent.TOGGLE_STATUS, toogleStatusFn, false, 0, true);
			_xml.addEventListener(LoaderEvent.LOADER_COMPLETE, xmlLoadCompleteFn, false, 0, true);
						
			//無設定載入預設值
			this.link = "../data/" + getQualifiedClassName(this) + ".xml";
		}
		
		//監聽從舞台移除(消滅)
		private function destroy(event:Event):void
		{			
			_singleton.removeEventListener(GeneralEvent.TOGGLE_STATUS, toogleStatusFn, false);
			_xml.removeEventListener(LoaderEvent.LOADER_COMPLETE, xmlLoadCompleteFn, false);
			
			//復原Tweener秒數設定
			Tweener.setTimeScale(1);
			
			var id:Number = 1;
			var num:Number = _strokeAry.length;
						
			for(id ; id <= num ; id++)
			{
				var sp:Sprite;
				
				if(_strokeAry[id - 1].stroke is Array)
				{					
					var aryId:Number = 1;
					var aryNum:Number = _strokeAry[id - 1].stroke.length;
					
					for(aryId ; aryId <= aryNum ; aryId++)
					{
						sp = _strokeAry[id - 1].stroke[aryId - 1];
						
						//移除Tweener;
						Tweener.removeTweens(sp);
					}
				}
				else
				{
					sp = _strokeAry[id - 1].mask;
					
					//移除Tweener;
					Tweener.removeTweens(sp);
				}
			}
		}
		
		//======================↓設定監聽GeneralEvent↓======================//
		
		//監聽觸發狀態事件
		private function toogleStatusFn(event:GeneralEvent):void
		{
			if(event.state == "Cross" && event.value == "Play")
			{
				Tweener.resumeTweens(_nowMask);
				return;
			}
			
			if(event.state == "Cross" && event.value == "Pause")
			{
				Tweener.pauseTweens(_nowMask);
				return;
			}
			
			if(event.state == "Cross" && event.value == "Replay")
			{
				//重置筆劃
				resetStroke();
				
				//移動筆劃
				moveStroke();
				
				return;
			}
			
			if(event.state == "Link")
				return initLink(event.value);
			
			if(event.state == "Speed")
				return changeSpeed(event.value);
		}
		
		//======================↑設定監聽GeneralEvent↑======================//
		//======================↓設定監聽LoaderEvent ↓======================//
				
		//監聽XML讀取解析完畢
		protected function xmlLoadCompleteFn(event:LoaderEvent):void
		{			
			//初始化筆劃
			initStroke();
			
			//移動筆劃
			moveStroke();
		}
				
		//======================↑設定監聽LoaderEvent ↑======================//
		//=======================↓設定Animation 功能↓=======================//
		
		//初始化連結
		private function initLink(value:String):void
		{			
			this.link = value;
		}
		
		//初始化筆劃
		protected function initStroke(value:Number = 0x000000):void
		{
			///初始化現在比劃id
			_nowStrokeId = 1;
			
			///初始化全部比劃數
			_allStrokeNum = _xml.content.length;
			
			//初始化筆畫陣列
			_strokeAry = [];
			
			var col:ColorTransform =new ColorTransform ();
			var dir:Number;
			var mc:MovieClip;
			var sp:Sprite;
			
			//設定顏色
			col.color = value;
			
			var id:Number = _nowStrokeId;
			var num:Number = _allStrokeNum;
						
			for(id ; id <= num ; id++)
			{				
				var obj:Object = new Object();
				var ary:Array = _xml.content[id - 1].direction.split(",");
				
				if(ary.length > 1)
				{
					obj.direction = [];
					obj.stroke = [];
					obj.mask = [];
					
					var aryId:Number = 1;
					var aryNum:Number = ary.length;
					
					for(aryId ; aryId <= aryNum ; aryId++)
					{
						dir = ary[aryId - 1];
						mc = getStroke(id, aryId);
						sp = getMask(mc, dir);
						
						obj.direction.push(dir);
						obj.stroke.push(mc);
						obj.mask.push(sp);
						
						//設定筆劃遮罩
						mc.mask = sp;
						mc.transform.colorTransform = col;
					}
				}
				else
				{
					dir = ary[0];
					mc = getStroke(id);
					sp = getMask(mc, dir);
					
					obj.direction = dir;
					obj.stroke = mc;
					obj.mask = sp;
					
					//設定筆劃遮罩
					mc.mask = sp;
					mc.transform.colorTransform = col;
				}
				
				_strokeAry[id - 1] = obj;
			}
		}
		
		//重設筆劃
		protected function resetStroke():void
		{
			//移除Tweener
			if(_nowMask) Tweener.removeTweens(_nowMask);
			
			//初始化現在比劃id
			_nowStrokeId = 1;
			
			//初始化全部比劃數
			_allStrokeNum = _xml.content.length;
			
			var dir:Number;
			var mc:MovieClip;
			var sp:Sprite;
			var pt:Point;
			
			var id:Number = 1;
			var num:Number = _strokeAry.length;
						
			for(id ; id <= num ; id++)
			{				
				if(_strokeAry[id - 1].stroke is Array)
				{					
					var aryId:Number = 1;
					var aryNum:Number = _strokeAry[id - 1].stroke.length;
					
					for(aryId ; aryId <= aryNum ; aryId++)
					{
						dir = _strokeAry[id - 1].direction[aryId - 1];
						mc = _strokeAry[id - 1].stroke[aryId - 1];
						sp = _strokeAry[id - 1].mask[aryId - 1];
						pt = getMaskStartPoint(mc, dir);
												
						//設定遮罩位置
						sp.x = pt.x;
						sp.y = pt.y;
					}
				}
				else
				{
					dir = _strokeAry[id - 1].direction;
					mc = _strokeAry[id - 1].stroke;
					sp = _strokeAry[id - 1].mask;
					pt = getMaskStartPoint(mc, dir);
					
					//設定遮罩位置
					sp.x = pt.x;
					sp.y = pt.y;
				}
			}
		}
		
		//移動筆畫
		protected function moveStroke():void
		{
			if(_strokeAry[_nowStrokeId - 1].stroke is Array)
			{
				_nowSubStrokeId = 1;
				_allSubStrokeNum = _strokeAry[_nowStrokeId - 1].stroke.length;
				
				return moveSubStroke();
			}
			
			var dir:Number = _strokeAry[_nowStrokeId - 1].direction;
			var mc:MovieClip = _strokeAry[_nowStrokeId - 1].stroke;
			var sp:Sprite = _strokeAry[_nowStrokeId - 1].mask;
			var spt:Point = getMaskStartPoint(mc, dir);
			var ept:Point = getMaskEndPoint(mc, dir);
			var dis:Number = Math.abs(Point.distance(spt, ept));
			
			trace(getQualifiedClassName(mc));
			
			//設定遮罩位置
			sp.x = spt.x;
			sp.y = spt.y;
			
			_nowDirection = dir;
			_nowStroke = mc;
			_nowMask = sp;
			
			//加入Tweener
			Tweener.addTween(_nowMask,
			{ 
				x: ept.x,
				y: ept.y,
				delay: 0.5,
				time: dis / _sizeArg * 3,
				transition: "easeOutCubic",
				onComplete: moveStrokeFinish
			});
		}
		
		//移動筆劃完成
		protected function moveStrokeFinish():void
		{			
			//移除Tweener
			Tweener.removeTweens(_nowMask);
						
			if(_nowStrokeId == _allStrokeNum)
				return;
			
			_nowStrokeId++;
			
			//移動筆劃
			moveStroke();
		}
		
		//移動次筆劃
		protected function moveSubStroke():void
		{			
			var dir:Number = _strokeAry[_nowStrokeId - 1].direction[_nowSubStrokeId - 1];
			var mc:MovieClip = _strokeAry[_nowStrokeId - 1].stroke[_nowSubStrokeId - 1];
			var sp:Sprite = _strokeAry[_nowStrokeId - 1].mask[_nowSubStrokeId - 1];
			var spt:Point = getMaskStartPoint(mc, dir);
			var ept:Point = getMaskEndPoint(mc, dir);
			var dis:Number = Math.abs(Point.distance(spt, ept));
						
			trace(getQualifiedClassName(mc));
			
			//設定遮罩位置
			sp.x = spt.x;
			sp.y = spt.y;
			
			_nowDirection = dir;
			_nowStroke = mc;
			_nowMask = sp;
			
			//加入Tweener
			Tweener.addTween(_nowMask,
			{ 
				x: ept.x,
				y: ept.y,
				time: dis / _sizeArg * 3 / _allSubStrokeNum,
				transition: _easeDict[_nowStrokeId % 2],
				onComplete: moveSubStrokeFinish
			});
		}
		
		//移動次筆劃完成
		protected function moveSubStrokeFinish():void
		{
			//移除Tweener
			Tweener.removeTweens(_nowMask);
			
			if(_nowSubStrokeId < _allSubStrokeNum)
			{
				_nowSubStrokeId++;
				
				//移動次筆劃
				return moveSubStroke();
			}
			
			if(_nowStrokeId < _allStrokeNum)
			{
				_nowStrokeId++;
			
				//移動筆劃
				return moveStroke();
			}
		}
		
		protected function getStroke(strokeId:Number, subStrokeId:Number = 0):MovieClip
		{
			var obj:DisplayObject;
			var id:Number = 1;
			var num:Number = this.numChildren;
			var name:String = (subStrokeId == 0) ? "S_" + strokeId.toString() : "S_" + strokeId.toString() + "_" + subStrokeId.toString();
			
			for(id ; id <= num ; id++)
			{
				obj = this.getChildAt(id - 1);
				
				if(name == getQualifiedClassName(obj))
					return MovieClip(obj);
			}
			
			return null;
		}
		
		//取得遮罩(目標物件、方向)
		protected function getMask(mc:MovieClip, dir:Number):Sprite
		{
			var ea:Number = _ellipseArg;
			var sa:Number = _sizeArg - _ellipseArg;
			var sp:Sprite = new Sprite();
			var pt:Point = getMaskStartPoint(mc, dir);
			
			sp.graphics.beginFill(0x000000);
			sp.graphics.moveTo(ea / 2, ea / 2);
			sp.graphics.curveTo(sa / 2, - ea / 2, sa + ea / 2, ea / 2);
			sp.graphics.curveTo(sa + ea + ea / 2, sa / 2, sa + ea / 2, sa + ea / 2);
			sp.graphics.curveTo(sa / 2, sa + ea + ea / 2, ea / 2, sa + ea / 2);
			sp.graphics.curveTo(- ea / 2, sa / 2, ea / 2, ea / 2);			
 			sp.graphics.endFill();
			sp.graphics.beginFill(0x000000);
			sp.graphics.drawRoundRect(ea / 4, ea / 4, sa + ea / 2, sa + ea / 2, ea, ea);
			sp.graphics.endFill();
			sp.x = pt.x;
			sp.y = pt.y;
			
			this.addChild(sp);
			
			return sp;
		}
		
		//取得開始座標(目標物件、方向)
		protected function getMaskStartPoint(mc:MovieClip, dir:Number):Point
		{
			var cv:Number = Math.abs(Math.sqrt(Math.pow(_ellipseArg / 4, 2) * 2));
			var pt:Point = new Point();
			
			switch(dir)
			{
				case 1:
					pt.x = mc.x + mc.width / 2 - _sizeArg / 2;
					pt.y = mc.y - _sizeArg;
					break;
				case 2:
					pt.x = mc.x + mc.width - cv;
					pt.y = mc.y - _sizeArg + cv;
					break;
				case 3:
					pt.x = mc.x + mc.width;
					pt.y = mc.y  + mc.height / 2 - _sizeArg / 2;
					break;
				case 4:
					pt.x = mc.x + mc.width - cv;
					pt.y = mc.y + mc.height - cv;
					break;
				case 5:
					pt.x = mc.x + mc.width / 2 - _sizeArg / 2;
					pt.y = mc.y + mc.height;
					break;
				case 6:
					pt.x = mc.x - _sizeArg + cv;
					pt.y = mc.y + mc.height - cv;
					break;
				case 7:
					pt.x = mc.x - _sizeArg;
					pt.y = mc.y  + mc.height / 2 - _sizeArg / 2;
					break;
				case 8:
					pt.x = mc.x - _sizeArg + cv;
					pt.y = mc.y - _sizeArg + cv;
					break;
				default:
					trace("參數錯誤。");
			}
			
			return pt;
		}
		
		//取得結束座標(目標物件、方向)
		protected function getMaskEndPoint(mc:MovieClip, dir:Number):Point
		{
			var pt1:Point = getMaskStartPoint(mc, dir);
			var pt2:Point = new Point();
			
			switch(dir)
			{
				case 1:
					pt2.x = pt1.x;
					pt2.y = pt1.y + mc.height + 3;
					break;
				case 2:
					pt2.x = pt1.x - mc.width - 3;
					pt2.y = pt1.y + mc.height + 3;
					break;
				case 3:
					pt2.x = pt1.x - mc.width - 3;
					pt2.y = pt1.y;
					break;
				case 4:
					pt2.x = pt1.x - mc.width - 3;
					pt2.y = pt1.y - mc.height - 3;
					break;
				case 5:
					pt2.x = pt1.x;
					pt2.y = pt1.y - mc.height - 3;
					break;
				case 6:
					pt2.x = pt1.x + mc.width + 3;
					pt2.y = pt1.y - mc.height - 3;
					break;
				case 7:
					pt2.x = pt1.x + mc.width + 3;
					pt2.y = pt1.y;
					break;
				case 8:
					pt2.x = pt1.x + mc.width + 3;
					pt2.y = pt1.y + mc.height + 3;
					break;
				default:
					trace("參數錯誤。");
			}
			
			return pt2;
		}
				
		//改變速度
		protected function changeSpeed(mode:String):void
		{
			if(mode == "Up" && _speed < 3)
				_speed++;
			
			if(mode == "Down" && _speed > 1)
				_speed--;
			
			if(mode == "Reset")
				_speed = 2;
						
			switch(_speed)
			{
				case 1:
					Tweener.setTimeScale(0.5);
					break;
				case 2:
					Tweener.setTimeScale(1);
					break;
				case 3:
					Tweener.setTimeScale(3);
					break;
				default:
					trace("速度錯誤。");
			}
		}
		
		//=======================↑設定Animation 功能↑=======================//
    }  
}