package entrypoint;

import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;

using haxe.macro.Tools;

class Macro { 

  static var called = false;
  
  static function getMain() {
    var args = Sys.args();
    
    for (i in 0...args.length-1)
      switch args[i] {
        case '-main': return args[i + 1];
        default:
      }    
      
    throw 'No -main entry point defined';
  }
  
  static function init() {
    
    called = false;
    
    var main = getMain();
    
    Compiler.addGlobalMetadata(getMain(), '@:build(entrypoint.Macro.processMain())', true, true, false);
    Context.onGenerate(function (types) {
      var cls = Context.getType(main).getClass();
      
      if (cls.meta.has('autoEntry') == called)
        if (called)
          cls.meta.remove('autoEntry');
        else
          cls.meta.add('autoEntry', [macro true], (macro null).pos);
    });
  }
  
  macro static public function processMain():Array<haxe.macro.Expr.Field> {
    var ret = Context.getBuildFields();
    
    for (f in ret)
      switch f {
        case { name: 'main', kind: FFun(f)}:
          f.expr = macro {
            function main() ${f.expr};
            if (haxe.rtti.Meta.getType($i{Context.getLocalClass().get().name}).autoEntry == null)
              main();
            else
              ${doRun(macro main)};
          }  
        default:
      }
      
    return ret;
  }
  static public function run(e) {
    called = true;
    return doRun(e);
  }
  static function doRun(e) {
    return macro @:privateAccess entrypoint.EntryPoint.doRun($e);
  }
}