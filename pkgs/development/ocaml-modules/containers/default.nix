{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, cppo, gen, sequence, qtest, ounit, result
, qcheck }:

let

  mkpath = p:
      "${p}/lib/ocaml/${ocaml.version}/site-lib";

  version = "1.4";

in

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-containers-${version}";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "ocaml-containers";
    rev = version;
    sha256 = "1wbarxphdrxvy7qsdp4p837h1zrv0z83pgs5lbz2h3kdnyvz2f1i";
  };

  buildInputs = [ ocaml findlib ocamlbuild cppo gen sequence qtest ounit qcheck ];

  propagatedBuildInputs = [ result ];

  preConfigure = ''
    # The following is done so that the '#use "topfind"' directive works in the ocaml top-level
    export HOME="$(mktemp -d)"
    export OCAML_TOPLEVEL_PATH="${mkpath findlib}"
    cat <<EOF > $HOME/.ocamlinit
let () =
  try Topdirs.dir_directory (Sys.getenv "OCAML_TOPLEVEL_PATH")
  with Not_found -> ()
;;
EOF
  '';

  configureFlags = [
    "--enable-unix"
    "--enable-thread"
    "--enable-tests"
    "--enable-docs"
    "--disable-bench"
  ];

  doCheck = true;
  checkTarget = "test";

  createFindlibDestdir = true;

  meta = {
    homepage = https://github.com/c-cube/ocaml-containers;
    description = "A modular standard library focused on data structures";
    longDescription = ''
      Containers is a standard library (BSD license) focused on data structures,
      combinators and iterators, without dependencies on unix. Every module is
      independent and is prefixed with 'CC' in the global namespace. Some modules
      extend the stdlib (e.g. CCList provides safe map/fold_right/append, and
      additional functions on lists).

      It also features optional libraries for dealing with strings, and
      helpers for unix and threads.
    '';
    license = stdenv.lib.licenses.bsd2;
    platforms = ocaml.meta.platforms or [];
  };
}
