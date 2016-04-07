package entrypoint;

class EntryPoint { 
  static public dynamic function whenDone() {}

  macro static public function run(e) {
    return Macro.run(e);
  }
  
  static function doRun(f) {
    trace('before');
    f();
    trace('after');
    whenDone();
  }
}