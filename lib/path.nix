{lib, ...}: {
  join = base: rel: let
    isAbsolute = lib.hasPrefix "/" base;

    joinOne = relSingle: let
      resolved = builtins.foldl' (
        acc: part:
          if part == "" || part == "."
          then acc
          else if part != ".."
          then acc ++ [part]
          else if acc != [] && lib.last acc != ".."
          then lib.init acc
          else if isAbsolute
          then acc
          else acc ++ [".."]
      ) [] (lib.splitString "/" base ++ lib.splitString "/" relSingle);
    in
      if isAbsolute
      then "/" + lib.concatStringsSep "/" resolved
      else if resolved == []
      then "."
      else lib.concatStringsSep "/" resolved;
  in
    if builtins.isList rel
    then map joinOne rel
    else joinOne rel;
}
