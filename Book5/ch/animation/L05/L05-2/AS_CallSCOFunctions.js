/**

* @author DaYu

* @version 1.0.4

* @date created 2010/10/04

*/

//設定是否使用Scorm
var useScorm = false;



//是否開始閱讀(請勿修改)
var readingStarted = false;

//是否完成閱讀(請勿修改)
var readingFinished = false;

//閱讀開始
function readingStart()
{
	readingStarted = true;
	
	//檢查是否使用Scorm
	if(useScorm)
		loadPage();
}

//閱讀完畢
function readingFinish()
{
	readingFinished = true;
}

//閱讀變更
function readingChanged()
{
	//檢查是否使用Scorm
	if(!useScorm)
		return;
	
	//檢查是否開始課程
	if(!readingStarted)
		return;
	
	//檢查是否完成課程
	if(readingFinished)
		unloadPage();
	else
		doQuit();
}

//寫入自行定義值
function setSuspendData(chapter, section)
{
	var data = "chapter=" + chapter + "&section=" + section;
	
	doLMSSetValue( "cmi.core.lesson_location", data);
}

//取得自行定義值
function getSuspendData()
{
	var data = doLMSGetValue( "cmi.core.lesson_location" );

	if(data == "")
		data = "chapter=0&section=0"
	
	return data;
}