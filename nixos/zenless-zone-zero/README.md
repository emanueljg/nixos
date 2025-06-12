# zenless-zone-zero-nix

A Nix flake for Zenless Zone Zero running in wine with emmanuelrosa's mkwindowsapp. 

## Currently packaged version

**1.6**

## Quick start
Standard flake interface, what you'd expect.

- Run: `nix run github:emanueljg/zenless-zone-zero-nix`
- Install (NixOS): add default package to `environment.systemPackages`
- Install (home-manager): add default package to `home.packages`

## Requirements
Linux or macOS with flake-enabled Nix. Derivation needs ~70*2GB of space during evaluation, ~70GB when installed.


## Voice langs
By default, the ZZZ derivations are realised with the voice languages `en-us` and `ja-jp`. You may change this in the `voiceLangs` override:

```nix
zenless-zone-zero.override { voiceLangs = [ "ja-jp"]; }
```

## Updating ZZZ with bad internet
As with any other flake input, you can just `nix flake update` it and it'll just work; `.#packages.zenless-zone-zero` will always point to the latest version of ZZZ, with specific versions
being available at `#packages.zenless-zone-zero105`, `#packages.zenless-zone-zer0160` etc.

If you have a good internet connection, this'll probably work fine, but if you don't, that's another ~60GB of largely duplicated game source download, each patch. An unconventional solution in this case is to
leverage this flake's patch support. It uses official hoyo patch files, which means if you have your previous
derivation in store, it's only roughly ~4-6GB of additional download.

Here's how it works. You start out using ZZZ normally like this, currently on patch **1.5**:

```nix
# zenless-zone-zero.nix, rev a
{ pkgs, zenless-zone-zero, ... }: {
  environment.systemPackages = [
    # at this point in time, this flake attribute points to .zenless-zone-zero-150
    zenless-zone-zero.packages.${pkgs.system}.zenless-zone-zero
  ] 
}
```

Then, once a new version (here, **1.6**) rolls around:

```nix
# zenless-zone-zero.nix, rev b
{ pkgs, zenless-zone-zero, ... }: {
  environment.systemPackages = [
    zenless-zone-zero.packages.${pkgs.system}.zenless-zone-zero-160p150
  ] 
}
```
However, this method has obvious downsides:

1. More derivations need to be realised, meaning you need more storage space (or need to GC more frequently)
2. Building a patched derivation without the `srcFrom` derivation in `/nix/store` leads to a very inefficient build.
3. "chained" patched overrides from several versions back like this will eventually lead to the patching being more resource-intensive than just
   downloading each version game data from scratch

So only use this method in network-constrained environments, and make sure to keep override chaining (see point 3.) limited.

## "Will I get banned for playing ZZZ with this?"
This package only uses official Hoyo data from publicly available APIs to download & patch the game. There should be no reason for Hoyo to ban clients using this package.
But you never know. Only use this package if you're aware of the risks of using it.
 

## On purity
- **This Nix package is not truly pure.** Technically, ZZZ is a pure Nix derivation as in the actual realised derivation has a standard reproducible output.
 But during runtime, we copy over the derivation output (game dir) to an ephemeral readwrite environment where anything goes. We're forced to compromise
like this becauase Hoyo does a bunch of unpredicable meddling with the game dir:
  - saves logs
  - caches request data
  - streams minor patch data (from a different channel than major version downloads)
  - edits "state files" on each game launch
 Until someone recompiles game code with all of this ripped out, we'll have to live with this.

## TODO
- investigate bwrap possibility
- mod support?
- document minFree/maxFree
