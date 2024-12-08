# https://github.com/yorukot/superfile
# https://superfile.netlify.app/configure/custom-hotkeys/
with (import <nixpkgs> {config.allowUnfree = true;});
let
in mkShell {

  shellHook = ''
  	echo "Keybindings"
	  echo "https://superfile.netlify.app/configure/custom-hotkeys/"
    '';

  buildInputs = [
    superfile
  ];

}
