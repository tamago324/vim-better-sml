(*
 * Process information from 'mlton -show-def-use <file>' to be more suitable for
 * type queries (i.e., given cursor position in file, respond with a type).
 *
 * With a def-use (.du) file, it's it's easy to look up all uses given a def.
 * For type queries, we want to look up the single definition, given a location
 * (which may be either a use or a def).
 * Thus, we want to 'invert' the def-use file, to get a use-def (.ud) file.
 *
 * To get a feel for things, see test/test.du and test/test.ud.
 *   - test/test.du is what we start with, and
 *   - test/test.ud is what we end up with
 *
 * Lines come in pairs: a location (i.e., a use OR def) followed by a def
 * This means that each def will be printed n + 2 times if that def has n uses.
 *)

structure InvertDefUse =
struct
  open Util

  fun invert [defUseFilename] =
    let
      val file = TextIO.openIn defUseFilename

      fun init () =
        let
          val maybeFirstDef = TextIO.inputLine file
          val maybeFirstLine = TextIO.inputLine file
        in
          (case maybeFirstDef
             of SOME firstDef => (print firstDef; print firstDef)
              | _ => ());
          (maybeFirstDef, maybeFirstLine)
        end

      fun step (_, NONE) = NONE
        | step (NONE, _) = raise Fail "Impossible"
        | step (SOME curDef, SOME line) =
          if isUse line
          then
            let val curUse = line in
              print curUse;
              print curDef;
              SOME (SOME curDef, TextIO.inputLine file)
            end
          else
            let val nextDef = line in
              print nextDef;
              print nextDef;
              SOME (SOME nextDef, TextIO.inputLine file)
            end
    in
      eval init step;
      TextIO.closeIn file;
      OS.Process.success
    end
    | invert _ = OS.Process.failure

end
