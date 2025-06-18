package;
import haxe.macro.Expr;

class EngineMacro {
    public static macro function getEngineVersion():ExprOf<String> {
        #if !display
        return macro $v{sys.io.File.getContent("../engineVersion.txt").split("\n")[0]};
        #else
        return macro $v{"X.X.X"}
        #end
    }
}