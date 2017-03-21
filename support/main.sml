structure Main =
struct
  open Util

  fun makeMain main () =
    let val args = CommandLine.arguments () in
      OS.Process.exit (main args)
    end

  val foo = 42

  fun exit status =
    if OS.Process.isSuccess status
    then status
    else
      (println "def-use-util: A tool for manipulating mlton's def-use files.";
       println "";
       println "Usage:";
       println "  def-use-util invert <file>.du";
       println "  def-use-util unused <file>.du";
       status)

  fun main' argv =
    case argv
      of "invert"::rest => exit (InvertDefUse.invert rest)
       | "unused"::rest => exit (UnusedDefs.unused rest)
       | _ => exit OS.Process.failure

  fun main () = makeMain main' ()
end
