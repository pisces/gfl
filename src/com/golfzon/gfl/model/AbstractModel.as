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

package com.golfzon.gfl.model
{

import collection.ArrayList;

import flash.events.EventDispatcher;

/**
 *	@Author				KH Kim
 *	@Version			1.0 beta
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.08.20
 *	@Modify
 *	@Description
 */
public class AbstractModel extends EventDispatcher
{
    //--------------------------------------------------------------------------
	//
	//	Instance variables
	//
    //--------------------------------------------------------------------------
	
	private var _children:ArrayList;
	
	private var source:XML;
	
	/**
	 *	@Constructor
	 */
	public function AbstractModel() {
		_children = new ArrayList();
	}
	
    //--------------------------------------------------------------------------
	//
	//	Instance methods
	//
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //  Public
    //--------------------------------------------------------------------------
    
    /**
     *	Model 인스턴스를 자식 리스트에 추가한다.
     */
    public function add(model:AbstractModel):Boolean {
    	if( !_children.contains(model) )
    		return _children.add(model);
    	return false;
    }
    
    /**
     *	Model 인스턴스를 자식 리스트의 해당 인덱스에 추가한다.
     */
    public function addAt(model:AbstractModel, index:int):Boolean {
    	if( !_children.contains(model) )
    		return _children.addAt(model, index);
    	return false;
    }
    
    /**
     *	인덱스에 해당하는 자식을 반환한다.
     */
    public function getChildAt(index:int):AbstractModel {
    	return _children.getItemAt(index);
    }
    
    /**
     *	자식 객체의 인덱스를 반환한다.
     */
    public function getChildIndex(model:AbstractModel):int {
    	return _children.getItemIndex(model);
    }
    
    /**
     *	model 인스턴스 리스트를 반환한다.
     */
    public function children():Array {
    	return _children.source;
    }
    
    /**
     *	model 인스턴스의 갯수
     */
    public function numChildren():int {
    	return _children.source.length;
    }
    
    /**
     *	Model 인스턴스를 자식 리스트에서 삭제한다.
     */
    public function remove(model:AbstractModel):Boolean {
    	if( _children.contains(model) )
    		return _children.remove(model);
    	return false;
    }
    
    /**
     *	해당 인덱스의 Model 인스턴스를 자식 리스트에서 삭제한다.
     */
    public function removeAt(index:int):Boolean {
    	return remove(getChildAt(index));
    }
    
    /**
     *	원시 XML 객체를 반환한다.
     */
    public function getSource():XML {
		return source;
    }
    
    /**
     *	원시 XML 객체를 넣어 프로퍼티를 설정한다.
     */
    public function setSource(source:XML):void {
    	this.source = source;
    	
    	setProperties();
    }
    
    //--------------------------------------------------------------------------
    //  Internal
    //--------------------------------------------------------------------------
    
    /**
     *	TODO : 프로퍼티를 설정한다.
     */
    protected function setProperties():void {
    }
}

}