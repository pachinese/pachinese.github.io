/**

* @author DaYu

* @version 1.0.3

* @date created 2011/06/07

* @date updated 2014/01/07

* @project 華語文_筆順

*/

package calligraphy.core
{    
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	import caurina.transitions.Tweener;
	
	import dayu.events.LoaderEvent;
	import dayu.events.GeneralEvent;
	import dayu.static.Singleton;
	
	import calligraphy.core.Animation
  
	public class Stroke extends Animation
	{	
		//設定保護變數
		protected var _autoTips:Boolean;							//自動提示
		protected var _tipsing:Boolean;								//提示中
		protected var _drawing:Boolean;								//繪圖中
		protected var _complete:Boolean;							//完成
		protected var _range:Number;								//範圍
		protected var _drawRect:Rectangle;							//繪圖矩形
		protected var _drawAry:Array;								//繪圖陣列
		protected var _drawStartPoint:Point;						//繪圖開始座標
		protected var _drawEndPoint:Point;							//繪圖結束座標
		protected var _strokeStartPoint:Point;						//筆劃開始座標
		protected var _strokeEndPoint:Point;						//筆劃結束座標
		protected var _startDistance:Number;						//開始座標距離
		protected var _endDistance:Number;							//結束座標距離
		protected var _nowDraw:Sprite;								//現在繪圖
		
		//建構Stroke
		public function Stroke()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
			
			//初始化繪圖矩形
			_drawRect = new Rectangle(0, 0, 260, 260);
			
			//初始化範圍
			_range = 30;
		}
		
		//監聽加入舞台(初始化)
		private function init(event:Event):void
		{			
			_singleton.addEventListener(GeneralEvent.TOGGLE_STATUS, toogleStatusFn, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownFn, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveFn, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpFn, false, 0, true);
		}
		
		//監聽從舞台移除(消滅)
		private function destroy(event:Event):void
		{			
			_singleton.removeEventListener(GeneralEvent.TOGGLE_STATUS, toogleStatusFn, false);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownFn, false);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveFn, false);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpFn, false);
		}
		
		//=======================↓設定監聽MouseEvent↓=======================//
		
		//監聽滑鼠按下事件
		private function mouseDownFn(event:MouseEvent):void
		{
			if(_complete)
				return;
			
			if(_tipsing)
				return;
			
			if(!_drawRect.contains(mouseX, mouseY))
				return;
				
			_drawing = true;
			
			//開始繪圖
			startDraw();
		}
		
		//監聽滑鼠移動事件
		private function mouseMoveFn(event:MouseEvent):void
		{
			if(!_drawing)
				return;
				
			if(!_drawRect.contains(mouseX, mouseY))
				return wrongStroke(false);
			
			//結束繪圖
			endDraw();
			
			//檢查是否有次筆劃
			if(_strokeAry[_nowStrokeId - 1].stroke is Array)				
				checkSubStroke();													//檢查次筆劃			
		}
		
		//監聽滑鼠放開事件
		private function mouseUpFn(event:MouseEvent):void
		{
			if(_complete)
				return;
			
			if(_tipsing)
				return;
			
			if(!_drawRect.contains(mouseX, mouseY))
				return;
			
			_drawing = false;
			
			//結束繪圖
			endDraw();
			
			//檢查是否有次筆劃
			if(_strokeAry[_nowStrokeId - 1].stroke is Array)
				checkSubStroke();													//檢查次筆劃
			else				
				checkStroke();														//檢查筆劃
		}
		
		//=======================↑設定監聽MouseEvent↑=======================//
		//======================↓設定監聽GeneralEvent↓======================//
		
		//監聽觸發狀態事件
		private function toogleStatusFn(event:GeneralEvent):void
		{
			if(event.state == "Cross" && event.value == "Clear")
				return clearStroke();
			
			if(event.state == "Tips")
				return tipsStroke();
			
			if(event.state == "AutoTips" && event.value == "Show")
			{
				_autoTips = true;
				return tipsStroke();
			}
			
			if(event.state == "AutoTips" && event.value == "Hide")
			{
				_autoTips = false;
				return;
			}
		}
		
		//======================↑設定監聽GeneralEvent↑======================//
		//======================↓覆寫監聽LoaderEvent ↓======================//
		
		//監聽XML讀取解析完畢
		override protected function xmlLoadCompleteFn(event:LoaderEvent):void
		{			
			//初始化筆劃
			initStroke(0x70D9E8);
			
			//初始化繪圖
			initDraw();
			
			//新繪圖
			newDraw();
		}
		
		//======================↑覆寫監聽LoaderEvent ↑======================//
		//=======================↓覆寫Animation 功能↓=======================//
		
		//移動筆劃完成
		override protected function moveStrokeFinish():void
		{
			//移除Tweener
			Tweener.removeTweens(_nowMask);
			
			_tipsing = false;
		}
				
		//移動次筆劃完成
		override protected function moveSubStrokeFinish():void
		{
			//移除Tweener
			Tweener.removeTweens(_nowMask);
			
			//檢查是否有此筆劃
			if(_nowSubStrokeId < _allSubStrokeNum)
			{
				_nowSubStrokeId++;
				
				return moveSubStroke();
			}
			
			_nowSubStrokeId = 1;
			
			_nowDirection = _strokeAry[_nowStrokeId - 1].direction[_nowSubStrokeId - 1];
			_nowStroke = _strokeAry[_nowStrokeId - 1].stroke[_nowSubStrokeId - 1];
			_nowDraw = _drawAry[_nowStrokeId - 1][_nowSubStrokeId - 1];
			
			_tipsing = false;
		}		
		
		//=======================↑覆寫Animation 功能↑=======================//
		//=========================↓設定Stroke功能↓=========================//
		
		//初始化繪圖
		protected function initDraw():void
		{
			//初始化繪圖陣列
			_drawAry = [];
			
			var mcClass:Class;
			var mc:MovieClip;
			var sp:Sprite;
						
			var id:Number = 1;
			var num:Number = _strokeAry.length;
						
			for(id ; id <= num ; id++)
			{
				//檢查是否有次筆劃
				if(_strokeAry[id - 1].stroke is Array)
				{
					_drawAry[id - 1] = [];
					
					var aryId:Number = 1;
					var aryNum:Number = _strokeAry[id - 1].mask.length;
					
					for(aryId ; aryId <= aryNum ; aryId++)
					{						
						mcClass = getDefinitionByName("S_" + id.toString() + "_" + aryId.toString()) as Class
						mc = new mcClass();
						mc.x = _strokeAry[id - 1].stroke[aryId - 1].x;
						mc.y = _strokeAry[id - 1].stroke[aryId - 1].y;
						sp = new Sprite();						
						sp.mask = mc;
												
						this.addChild(mc);
						this.addChild(sp);
						
						_drawAry[id - 1][aryId - 1] = sp;
					}
				}
				else
				{					
					mcClass = getDefinitionByName("S_" + id.toString()) as Class;
					mc = new mcClass();
					mc.x = _strokeAry[id - 1].stroke.x;
					mc.y = _strokeAry[id - 1].stroke.y;
					sp = new Sprite();				
					sp.mask = mc;
										
					this.addChild(mc);
					this.addChild(sp);
					
					_drawAry[id - 1] = sp;
				}
			}			
		}
				
		//開始繪圖
		protected function startDraw():void
		{
			_drawStartPoint = new Point(mouseX, mouseY);
			_nowDraw.graphics.moveTo(_drawStartPoint.x, _drawStartPoint.y);
			
			//設定筆劃樣式
			_nowDraw.graphics.lineStyle(20, 0);
		}
		
		//結束繪圖
		protected function endDraw():void
		{
			_drawEndPoint = new Point(mouseX, mouseY);
			_nowDraw.graphics.lineTo(_drawEndPoint.x, _drawEndPoint.y);
		}
				
		//新繪圖
		protected function newDraw():void
		{			
			//檢查是否有次筆劃
			if(_strokeAry[_nowStrokeId - 1].stroke is Array)
			{
				_nowSubStrokeId = 1;
				_allSubStrokeNum = _drawAry[_nowStrokeId - 1].length;
								
				//現在方向
				_nowDirection = _strokeAry[_nowStrokeId - 1].direction[_nowSubStrokeId - 1];
				
				//現在筆劃
				_nowStroke = _strokeAry[_nowStrokeId - 1].stroke[_nowSubStrokeId - 1];
				
				//現在繪圖
				_nowDraw = _drawAry[_nowStrokeId - 1][_nowSubStrokeId - 1];
			}
			else
			{
				//現在方向
				_nowDirection = _strokeAry[_nowStrokeId - 1].direction;
				
				//現在筆劃
				_nowStroke = _strokeAry[_nowStrokeId - 1].stroke;
				
				//現在繪圖
				_nowDraw = _drawAry[_nowStrokeId - 1];
			}
			
			if(_autoTips)
				return tipsStroke();
		}
				
		//檢查筆劃
		protected function checkStroke():void
		{			
			var pass:Boolean = countCondition();
			
			if(pass)
				return rightStroke(true);
			else
				return wrongStroke(true);
		}
		
		//檢查次筆劃
		protected function checkSubStroke():void
		{			
			var id:Number = 1;
			var num:Number = _allSubStrokeNum;
			var pass:Boolean = countCondition();
			var sub:Boolean = _nowSubStrokeId < _allSubStrokeNum;
						
			//檢查是否繪圖中、是否通過、是否有次筆劃
			if(_drawing && pass && sub)
			{			
				//現在筆劃
				_nowStroke = _strokeAry[_nowStrokeId - 1].stroke[_nowSubStrokeId - 1];
					
				//現在繪圖
				_nowDraw = _drawAry[_nowStrokeId - 1][_nowSubStrokeId - 1];
					
				//填滿現在繪圖
				_nowDraw.graphics.beginFill(0x000000);
				_nowDraw.graphics.drawRect(_nowStroke.x, _nowStroke.y, _nowStroke.width, _nowStroke.height);
				_nowDraw.graphics.endFill();
				
				_nowSubStrokeId++;
				
				_nowDirection = _strokeAry[_nowStrokeId - 1].direction[_nowSubStrokeId - 1];
				_nowStroke = _strokeAry[_nowStrokeId - 1].stroke[_nowSubStrokeId - 1];
				_drawStartPoint = getStrokeStartPoint(_nowStroke, _nowDirection);
				_nowDraw = _drawAry[_nowStrokeId - 1][_nowSubStrokeId - 1];				
				_nowDraw.graphics.moveTo(_drawStartPoint.x, _drawStartPoint.y);
				_nowDraw.graphics.lineStyle(20, 0);
			}
			
			//檢查是否繪圖停止、是否有次筆劃
			if(!_drawing && sub)				
				return wrongStroke(true);
				
			//檢查是否繪圖停止、是否無通過
			if(!_drawing && !pass)				
				return wrongStroke(true);
			
			//檢查是否繪圖停止、是否通過
			if(!_drawing && pass)				
				return rightStroke(true);			
		}
		
		//計算條件
		protected function countCondition():Boolean
		{
			_strokeStartPoint = getStrokeStartPoint(_nowStroke, _nowDirection);
			_strokeEndPoint = getStrokeEndPoint(_nowStroke, _nowDirection);
			
			_startDistance = Point.distance(_strokeStartPoint, _drawStartPoint);
			_endDistance = Point.distance(_strokeEndPoint, _drawEndPoint);
			
			//除錯資訊
			debugInfo();
			
			return (_startDistance < _range && _endDistance < _range);
		}
		
		//正確筆劃
		protected function rightStroke(sound:Boolean):void
		{
			//填滿現在繪圖
			_nowDraw.graphics.beginFill(0x000000);
			_nowDraw.graphics.drawRect(_nowStroke.x, _nowStroke.y, _nowStroke.width, _nowStroke.height);
			_nowDraw.graphics.endFill();
			
			//檢查是否播放音效
			if(sound)
			{
				//觸發正確音效
				_singleton.dispatchEvent(new GeneralEvent(GeneralEvent.TOGGLE_STATUS, "SoundEffect", "Right"));
			}
			
			//檢查筆劃是否完成
			if(_nowStrokeId == _allStrokeNum)
			{
				//設定為完成
				_complete = true;
			}
			else
			{
				//增加現在筆劃id
				_nowStrokeId++;
				
				//新繪圖
				newDraw();
			}
		}
		
		//正確筆劃
		protected function wrongStroke(sound:Boolean):void
		{
			//檢查是否有次筆劃
			if(_strokeAry[_nowStrokeId - 1].stroke is Array)
			{
				for(_nowSubStrokeId = 1 ; _nowSubStrokeId <= _allSubStrokeNum ; _nowSubStrokeId++)
				{
					//現在繪圖
					_nowDraw = _drawAry[_nowStrokeId - 1][_nowSubStrokeId - 1];
					
					//清空現在繪圖
					_nowDraw.graphics.clear();
				}
			}
			else
			{
				//清空現在繪圖
				_nowDraw.graphics.clear();
			}
			
			//檢查是否播放音效
			if(sound)
			{
				//觸發錯誤音效
				_singleton.dispatchEvent(new GeneralEvent(GeneralEvent.TOGGLE_STATUS, "SoundEffect", "Wrong"));
			}
			
			//新繪圖
			return newDraw();
		}
		
		//清除筆劃
		protected function clearStroke():void
		{
			var num:Number = _strokeAry.length;
			
			for(var id:Number = 1 ; id <= num ; id++)
			{
				//檢查是否有次筆劃
				if(_strokeAry[id - 1].stroke is Array)
				{
					var subNum:Number = _strokeAry[id - 1].stroke.length;
					
					for(var subId:Number = 1 ; subId <= subNum ; subId++)
					{
						//現在繪圖
						_nowDraw = _drawAry[id - 1][subId - 1];
						
						//清空現在繪圖
						_nowDraw.graphics.clear();
					}
				}
				else
				{
					//現在繪圖
					_nowDraw = _drawAry[id - 1];					
				
					//清空現在繪圖
					_nowDraw.graphics.clear();
				}
			}
						
			//設定為未完成
			_complete = false;
			
			//重製筆劃
			resetStroke();
			
			//新繪圖
			newDraw();
		}
		
		//提示筆劃
		protected function tipsStroke():void
		{
			_tipsing = true;
			
			//檢查是否有次筆劃
			if(_strokeAry[_nowStrokeId - 1].stroke is Array)
			{
				var id:Number = _nowSubStrokeId;
				var num:Number = _allSubStrokeNum;
					
				for(id ; id <= num ; id++)
				{
					var dir:Number = _strokeAry[_nowStrokeId - 1].direction[id - 1];
					var mc:MovieClip = _strokeAry[_nowStrokeId - 1].stroke[id - 1];
					var sp:Sprite = _strokeAry[_nowStrokeId - 1].mask[id - 1];
					var pt:Point = getMaskStartPoint(mc, dir);
												
					//設定遮罩位置
					sp.x = pt.x;
					sp.y = pt.y;
				}
			}
			
			//移動筆劃
			moveStroke();			
		}
		
		//取得筆劃開始座標
		protected function getStrokeStartPoint(mc:MovieClip, dir:Number):Point
		{
			var rect:Rectangle = new Rectangle(mc.x, mc.y, mc.width, mc.height);
			var pt:Point = new Point();
			
			switch(dir)
			{
				case 1:
					pt.x = rect.left + rect.width / 2;
					pt.y = rect.top;
					break;
				case 2:
					pt.x = rect.right;
					pt.y = rect.top;
					break;
				case 3:
					pt.x = rect.right;
					pt.y = rect.top + rect.height / 2;
					break;
				case 4:
					pt.x = rect.bottomRight.x;
					pt.y = rect.bottomRight.y;
					break;
				case 5:
					pt.x = rect.left + rect.width / 2;
					pt.y = rect.bottom;
					break;
				case 6:
					pt.x = rect.left;
					pt.y = rect.bottom;
					break;
				case 7:
					pt.x = rect.left;
					pt.y = rect.top + rect.height / 2;
					break;
				case 8:
					pt.x = rect.topLeft.x;
					pt.y = rect.topLeft.y;
					break;
				default:
					trace("參數錯誤。");
			}
			
			return pt;
		}
		
		//取得筆劃結束座標
		protected function getStrokeEndPoint(mc:MovieClip, dir:Number):Point
		{
			var rect:Rectangle = new Rectangle(mc.x, mc.y, mc.width, mc.height);
			var pt:Point = new Point();
			
			switch(dir)
			{
				case 1:
					pt.x = rect.left + rect.width / 2;
					pt.y = rect.bottom;
					break;
				case 2:
					pt.x = rect.left;
					pt.y = rect.bottom;
					break;
				case 3:
					pt.x = rect.left;
					pt.y = rect.top + rect.height / 2;
					break;
				case 4:
					pt.x = rect.topLeft.x;
					pt.y = rect.topLeft.y;
					break;
				case 5:
					pt.x = rect.left + rect.width / 2;
					pt.y = rect.top;
					break;
				case 6:
					pt.x = rect.right;
					pt.y = rect.top;
					break;
				case 7:
					pt.x = rect.right;
					pt.y = rect.top + rect.height / 2;
					break;
				case 8:
					pt.x = rect.bottomRight.x;
					pt.y = rect.bottomRight.y;
					break;
				default:
					trace("參數錯誤。");
			}
			
			return pt;
		}
		
		//除錯資訊
		protected function debugInfo():void
		{
			trace("筆劃開始座標：", _strokeStartPoint);
			trace("筆劃結束座標：", _strokeEndPoint);
			trace("繪圖開始座標：", _drawStartPoint);
			trace("繪圖結束座標：", _drawEndPoint);
			trace("開始座標距離：", _startDistance);
			trace("結束座標距離：", _endDistance);
		}
		
		//=========================↑設定Stroke功能↑=========================//
    }  
}