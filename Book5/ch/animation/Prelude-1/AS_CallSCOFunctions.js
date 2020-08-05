/**

* @author DaYu

* @version 1.0.4

* @date created 2010/10/04

*/

//�]�w�O�_�ϥ�Scorm
var useScorm = false;



//�O�_�}�l�\Ū(�Фŭק�)
var readingStarted = false;

//�O�_�����\Ū(�Фŭק�)
var readingFinished = false;

//�\Ū�}�l
function readingStart()
{
	readingStarted = true;
	
	//�ˬd�O�_�ϥ�Scorm
	if(useScorm)
		loadPage();
}

//�\Ū����
function readingFinish()
{
	readingFinished = true;
}

//�\Ū�ܧ�
function readingChanged()
{
	//�ˬd�O�_�ϥ�Scorm
	if(!useScorm)
		return;
	
	//�ˬd�O�_�}�l�ҵ{
	if(!readingStarted)
		return;
	
	//�ˬd�O�_�����ҵ{
	if(readingFinished)
		unloadPage();
	else
		doQuit();
}

//�g�J�ۦ�w�q��
function setSuspendData(chapter, section)
{
	var data = "chapter=" + chapter + "&section=" + section;
	
	doLMSSetValue( "cmi.core.lesson_location", data);
}

//���o�ۦ�w�q��
function getSuspendData()
{
	var data = doLMSGetValue( "cmi.core.lesson_location" );

	if(data == "")
		data = "chapter=0&section=0"
	
	return data;
}