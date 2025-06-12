{ stdenv
, fetchFromGitHub
, lib

, ldefSupport ? true
, md5Support ? true
, zstdSupport ? true
, bzip2Support ? true
, lzmaSupport ? true
}:
stdenv.mkDerivation (self: {
  pname = "hdiffpatch";
  version = "4.8.0";
  srcs = [
    (fetchFromGitHub {
      name = "sisong-hdiffpatch";
      owner = "sisong";
      repo = "HDiffPatch";
      tag = "v${self.version}";
      hash = "sha256-IVw6sq/hz66XZ8Uh5uSIk9iXEi8NSR5ZBKF/yrowPbE=";
    })
  ] ++ lib.optionals ldefSupport [
    (fetchFromGitHub {
      name = "sisong-zlib";
      owner = "sisong";
      repo = "zlib";
      rev = "bit_pos_padding";
      hash = "sha256-oW+mIHHFrdwZEDbIrgr9MDTJYuqiJMhYAUqAVcCG1CY=";
    })
    (fetchFromGitHub {
      name = "sisong-libdeflate";
      owner = "sisong";
      repo = "libdeflate";
      rev = "stream-mt";
      hash = "sha256-I5QEeGyvUUoJdpEws6+v6Yw7s2oM61v6U1hJAIUcVmI=";
    })
  ]
  ++ lib.optional md5Support
    (fetchFromGitHub {
      name = "sisong-libmd5";
      owner = "sisong";
      repo = "libmd5";
      rev = "master";
      hash = "sha256-xjr3WQvG28xDPAONtE6jYkW8nlMfV0KL6HE4csI08YI=";
    })
  ++ lib.optional zstdSupport
    (fetchFromGitHub {
      name = "sisong-zstd";
      owner = "sisong";
      repo = "zstd";
      rev = "deltaUpdateDict";
      hash = "sha256-h4Lqqdtkrhw9tc3OfNEdKrglaziTOIknfxak/aIvIY4=";
    })
  ++ lib.optional bzip2Support
    (fetchFromGitHub {
      name = "sisong-bzip2";
      owner = "sisong";
      repo = "bzip2";
      rev = "master";
      hash = "sha256-kg/y9ZGbvaQd86tXxekxcv+h8nbNk3UvWad50fm5FtA=";
    })
  ++ lib.optional lzmaSupport
    (fetchFromGitHub {
      name = "sisong-lzma";
      owner = "sisong";
      repo = "lzma";
      rev = "fix-make-build";
      hash = "sha256-ECvHeoRgxZ3ebVcWkRkZ1NyzxqkInQieqXnuGv/0VCg=";
    });

  postUnpack =
    lib.concatMapStringsSep "\n"
      (sisongPkg: "if [ -d sisong-${sisongPkg} ]; then cp -r --no-preserve=mode sisong-${sisongPkg} ${sisongPkg}; fi")
      [ "zlib" "libdeflate" "libmd5" "zstd" "bzip2" "lzma" ];

  sourceRoot = "${(builtins.elemAt self.srcs 0).name}";

  makeFlags =
    let
      bool = x: if x then "1" else "0";
    in
    [
      "LDEF=${bool ldefSupport}"
      "MD5=${bool md5Support}"
      "ZSTD=${bool zstdSupport}"
      "BZIP2=${bool bzip2Support}"
      "LZMA=${bool lzmaSupport}"
    ];

  installPhase = ''
    mkdir -p $out/bin
    cp {hdiffz,hpatchz} $out/bin
  '';

  meta.mainProgram = "hdiffz";
})
