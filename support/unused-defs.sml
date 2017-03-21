(**
 * Filter information from 'mlton -show-def-use <file>' to list only unused
 * definitions.
 *
 * A definition is unused if it's not followed by any uses.
 *
 * To get a feel for things, see test/test.du and test/test.ud.
 *   - test/test.du is what we start with, and
 *   - test/test.unused is what we end up with
 *
 *)

structure UnusedDefs =
struct
  open Util

  fun asWarning def limitTo =
    let
      val idType::id::filename::linecol::_ = String.tokens Char.isSpace def
    in
      if String.isPrefix limitTo filename
      then
        String.concatWith " "
          [ "Warning:", filename, linecol, "\n ", idType, id, "is unused.\n" ]
      else ""
    end


  fun unused [defUseFilename] =
    let
      val file = TextIO.openIn defUseFilename
      val limitTo = OS.Path.getParent (resolve defUseFilename)

      fun init () =
        (false,
         TextIO.inputLine file,
         TextIO.inputLine file)

      fun step (_, NONE, NONE) = NONE
        | step (_, SOME curDef, NONE) =
          (* def on last line of file: implicitly never used. *)
          (print (asWarning curDef limitTo);
           NONE)
        | step (used, SOME curDef, SOME line) =
          if isUse line
          then
            SOME (true, SOME curDef, TextIO.inputLine file)
          else
            let val nextDef = line in
              (* print only if it was unused, and reset to 'false' for next *)
              (if not used then print (asWarning curDef limitTo) else ();
               SOME (false, (SOME nextDef), TextIO.inputLine file))
            end
        | step (_, NONE, SOME _) = raise Fail "Impossible"
    in
      eval init step;
      TextIO.closeIn file;
      OS.Process.success
    end
    | unused _ = OS.Process.failure
end

