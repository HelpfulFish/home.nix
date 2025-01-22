final: prev:

# rev and hash can also be found on GitHub
# example below of version change pinned for anki
# https://github.com/NixOS/nixpkgs/commit/cd384ccef34a8775139806ffaaf4877fa4772000#diff-842c28011dea7cf618f4a78aa8589cd9f11a37f8a66201f5bf28ed54efff4748L38

{
  anki = prev.anki.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "d678e39350a2d243242a69f4e22f5192b04398f2";
      # If you don't know the hash, the first time, set:
      # hash = "";
      # then nix will fail the build with such an error message:
      # hash mismatch in fixed-output derivation '/nix/store/m1ga09c0z1a6n7rj8ky3s31dpgalsn0n-source':
      # specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
      # got:    sha256-173gxk0ymiw94glyjzjizp8bv8g72gwkjhacigd1an09jshdrjb4
      hash = "sha256-pAQBl5KbTu7LD3gKBaiyn4QiWeGYoGmxD3sDJfCZVdA=";
    };
  });
}
