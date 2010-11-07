////////////////////////////////////////////////////////////////////////////////
//
//  GOLFZON
//  Copyright(c) GOLFZON.CO.,LTD.
//  All Rights Reserved.
//
//  NOTICE: GOLFZON permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.golfzon.gfl.utils
{

import com.adobe.utils.ObjectUtil;
	
/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2010. 3. 24.
 *	@Modify
 *	@Description
 */
public class SimpleXMLDecoder
{
	/**
	 *	@Constructor
	 */
	public function SimpleXMLDecoder() {
	}
	
	//--------------------------------------------------------------------------
	//
	//  Instance methods
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Public
	//--------------------------------------------------------------------------
	
	/**
	 *	XML 원시데이타를 파싱해 Object로 반환한다.
	 */
	public function decodeXML(res:XML):Object {
		return createProperties(res);
	}
	
	//--------------------------------------------------------------------------
	//	Internal
	//--------------------------------------------------------------------------
	
	private function createProperties(res:XML):Object {
		var result:Object = {};
		
		// 속성 부여
		for each( var res_attrubute:XML in res.attributes() ) {
			var res_attrubute_name:String = res_attrubute.name().toString();
			result[res_attrubute_name] = res_attrubute.toString();
		}
		
		for each( var res_child:XML in res.children() ) {
			var res_child_name:String = res_child.name().toString();
			result[res_child_name] = {};
			
			// 하위 객체 생성 및 속성 부여
			for each( var res_child_attribute:XML in res_child.attributes() ) {
				var res_child_attribute_name:String = res_child_attribute.name().toString();
				result[res_child_name][res_child_attribute_name] = res_child_attribute.toString();
			}
			
			if( res_child.children() ) {
				for( var i:uint=0; i<res_child.children().length(); i++ ) {
					var res_child_child:XML = res_child.children()[i];
					var res_child_child_name:String = res_child_child.name().toString() + "s";
					
					if( result[res_child_name][res_child_child_name] == undefined )
						result[res_child_name][res_child_child_name] = [];
					
					result[res_child_name][res_child_child_name][i] = createProperties(res_child_child);
				}
				
			}
		}
		return result;
	}
}
	
}