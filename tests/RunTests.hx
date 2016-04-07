package;

class RunTests {
  static var log = [];
  static function __init__() {
    var old = haxe.Log.trace;
    haxe.Log.trace = function (m:Dynamic, ?_) {
      log.push(Std.string(m));
    }
    
    entrypoint.EntryPoint.whenDone = function () {
      switch log {
        #if manual
          case ['main', 'before', 'manual', 'after']:
        #else  
          case ['before', 'main', 'after']:
        #end
        default:
          throw 'assert';
      }
      old(log);
    }
  }
  static function main() {
    trace('main');
    #if manual
    entrypoint.EntryPoint.run(function () trace('manual'));
    #end

  }
  
}