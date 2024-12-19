{ pkgs, ... }:

let
  strip-metadata = pkgs.writeShellScriptBin "strip-metadata" ''
    #!/bin/sh

TARGET_DIR="/home/$USER/.config/home-manager/modules/programs/wallpapers"

if [ ! -d "$TARGET_DIR" ]; then
  echo "Directory $TARGET_DIR does not exist."
  exit 1
fi

# Iterate through all files in the directory (excluding README.md)
for file in "$TARGET_DIR"/*; do
  # Skip if the file is README.md or not an image file
  if [ "$(basename "$file")" = "README.md" ]; then
    continue
  fi

  # Check if the file is an image
  file_type=$(file --mime-type -b "$file")
  case $file_type in
    image/*)
      echo "Stripping metadata from: $file"
      mogrify -strip "$file"
      ;;
    *)
      echo "Skipping non-image file: $file"
      ;;
  esac
done

echo "Metadata clearing completed."

  '';
in {
  home.packages = [
   strip-metadata 
  ];
}

