package input2actions.util;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
using haxe.macro.Tools;
#end

class EnumMacros {
  
	public static macro function getNameValueMap(typePath:Expr):Expr 
	{
		var type = Context.getType(typePath.toString());

		switch (type.follow())
		{
			case TAbstract(_.get() => c, _) if (c.meta.has(":enum")):
				var nameValueMap:Array<Expr> = [];
				for (field in c.impl.get().statics.get()) 
				{
					if (field.meta.has(":enum") && field.meta.has(":impl")) {
						var fieldName = field.name;
						nameValueMap.push(macro $v{fieldName} => $typePath.$fieldName);
					}
				}
				return macro $a{nameValueMap};
				
			default: throw new Error(type.toString() + " isn't a @:enum abstract.", typePath.pos);
		}
	}
  
	public static macro function getValueNameMap(typePath:Expr):Expr 
	{
		var type = Context.getType(typePath.toString());

		switch (type.follow())
		{
			case TAbstract(_.get() => c, _) if (c.meta.has(":enum")):
				var nameValueMap:Array<Expr> = [];
				for (field in c.impl.get().statics.get()) 
				{
					if (field.meta.has(":enum") && field.meta.has(":impl")) {
						var fieldName = field.name;
						nameValueMap.push(macro $typePath.$fieldName => $v{fieldName} );
					}
				}
				return macro $a{nameValueMap};
				
			default: throw new Error(type.toString() + " isn't a @:enum abstract.", typePath.pos);
		}
	}
  
}