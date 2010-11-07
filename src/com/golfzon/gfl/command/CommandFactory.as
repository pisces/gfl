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

package com.golfzon.gfl.command
{
 
import flash.utils.getDefinitionByName;

/**
 *	@Author				KHKim
 *	@Version			1.0
 *	@Lanaguage			Action Script 3.0
 *	@Date				2009.03.07
 *	@Modify
 *	@Description
 */
public class CommandFactory
{
	/**
	 *	@Constructor
	 */
	public function CommandFactory() {
		throw new Error("CommandFactory is not allowed instnacing!");
	}
	
	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------

	/**
	 *	Create a new command by name.
	 */
	public static function create(receiver:IReceiver, name:String, parameters:Array=null):ICommand {
		var head:String = name.slice(0, 1);
		var body:String = name.slice(1, name.length);
		var classPath:String =  receiver.commandPackageRoute + "." + head.toLocaleUpperCase() + body + "Command";
		var definition:Class = getDefinitionByName(classPath) as Class;
		return ICommand(new definition(receiver, parameters));
	}
}

}