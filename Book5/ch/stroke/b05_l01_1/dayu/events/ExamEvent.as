/**

* @author DaYu

* @version 1.0.1

* @date created 2011/05/03

*/

package dayu.events
{   
	import flash.events.Event;
	
	public class ExamEvent extends Event  
	{
		//設定私域變數
		private var _value:*;			//自定事件參數value(任意值)
		
		//設定全域ExamEvent事件常數
		public static const START_EXAM:String = "startExam";  				//開始測驗
		public static const RETRY_EXAM:String = "retryExam";  				//重試測驗
		public static const FINISH_EXAM:String = "finishExam";  			//完成測驗
				
		public static const SELECT_ANSWER:String = "selectAnswer";  		//選擇答案
		public static const SUBMIT_ANSWER:String = "submitAnswer";  		//提交答案
		public static const RETRY_QUESTION:String = "retryQuestion";  		//重試題目
		public static const CHANGE_QUESTION:String = "changeQuestion";  	//變更題目
		public static const EXPLAIN_QUESTION:String = "explainQuestion";  	//詳解題目
		public static const SHOW_FEEDBACK:String = "showFeedback";  		//顯示回饋
		public static const SHOW_ALL_FEEDBACK:String = "showAllFeedback";  	//顯示總回饋
		
		public static const RELEARN_COURSE:String = "relearnCourse";		//重新學習課程
								
		//取得ExamEvent自帶參數value(任意值)
		public function get value():* { return _value; }
		
		//建構ExamEvent函數
		public function ExamEvent(type:String , value:* = undefined)
		{
			//建構父類別(事件類型、可以反昇、無法取消)
			super(type, true, false);
			
			_value = value;
		}
 	}
}
