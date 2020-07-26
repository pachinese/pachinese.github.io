/**

* @author DaYu

* @version 1.0.2

* @date created 2011/05/11

*/

package dayu.static
{
	public class XmlEx extends Object
	{
		//建構XmlEx
		public function XmlEx(singletonEnforcer:SingletonEnforcer)
		{
			if(! singletonEnforcer is SingletonEnforcer || singletonEnforcer == null)
			{
				throw new Error("XmlEx can not create by New.");
			}
		}
		
		//轉換成Array
		public static function toArray(xml:XML):Array
		{
			return analyzeXMLList(xml.children());
		}
		
		//解析XMLList
		public static function analyzeXMLList(xmlList:XMLList):Array
		{
			var ary:Array = [];
						
			for each (var xml in xmlList)
			{				
				//檢查XML是否為簡單內容
				if(xml.hasSimpleContent())
				{
					if(xml.toString() != "" && xml.text().length() == 0)
						continue;
										
					//將解析出來的XML存入ary
					ary.push(analyzeSimpleXML(xml));
					
					continue;
				}
				
				//檢查XMLList是否無重複且都有值
				if(!isRepeatXMLList(xml.children()) && xml.children().length() == xml.children().text().length())
				{
					//將解析出來的XML存入ary
					ary.push(analyzeComplexXML(xml));
					
					continue;
				}
								
				//再次執行解析XMLList並將解析值存入ary
				ary.push(analyzeXMLList(xml.children()));
			}
			
			return ary;
		}
		
		//是否為重複的XMLList
		public static function isRepeatXMLList(xmlList:XMLList):Boolean
		{
			var ary:Array = [];
						
			var isRepeat:Function = function(element:*, index:int, arr:Array):Boolean
			{				
				return (arr.indexOf(element) != arr.lastIndexOf(element));
			}
			
			for each (var item in xmlList)
			{				
				if(item.name() == null)
					continue;
				
				ary.push(item.name().toString());
			}
						
			return ary.some(isRepeat);
		}
				
		//解析簡單XML
		public static function analyzeSimpleXML(xml:XML):Object
		{
			//初始化物件
			var obj:Object = new Object();
			
			//取得此xml名稱
			var name:String = xml.name();
			
			//取得此xml值
			var value:String = xml.text().toXMLString();
			
			//將物件賦予屬性與值
			obj[name] = value;
			
			for each (var attr in xml.attributes())
			{
				//取得此屬性名稱
				name = attr.name();
				
				//取得此屬性值
				value = attr;
				
				//將物件賦予屬性與值
				obj[name] = value;
			}
			
			return obj;
		}
		
		//解析複雜XML
		public static function analyzeComplexXML(xml:XML):Object
		{			
			//初始化物件
			var obj:Object = new Object();
			
			//初始化xml名稱
			var name:String;
			
			//初始化xml值
			var value:String;
			
			for each (var attr in xml.attributes())
			{
				//取得此屬性名稱
				name = attr.name();
				
				//取得此屬性值
				value = attr;
				
				//將物件賦予屬性與值
				obj[name] = value;
			}
			
			for each (var item in xml.children())
			{
				//取得此xml名稱
				name = item.name();
				
				//取得此xml值
				value = item.text().toXMLString();
				
				//將物件賦予屬性與值
				obj[name] = value;
				
				for each (var iattr in item.attributes())
				{
					//取得此屬性名稱
					name = iattr.name();
				
					//取得此屬性值
					value = iattr;
					
					//將物件賦予屬性與值
					obj[name] = value;
				}
			}
			
			return obj;
		}
	}
}

internal class SingletonEnforcer {
}