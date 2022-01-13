# Plutus Pioneer Program

## Lectures

### [Lecture #1](https://www.youtube.com/playlist?list=PLNEK_Ejlx3x2nLM4fAck2JS6KhFQlXq2N)

 - [Part 1 - Welcome and Introduction](https://youtu.be/X80uNXenWF4)
 - [Part 2 - The EUTxO-Model](https://youtu.be/bfofA4MM0QE)
 - [Part 3 - Building the Example Code](https://youtu.be/zPaDp4R9X7o)
 - [Part 4 - Auction Contract in the EUTxO-Model](https://youtu.be/Bj6bqRGT1L0)
 - [Part 5 - Auction Contract on the Playground](https://youtu.be/K61Si6iQ-Js)
 - [Part 6 - Homework](https://youtu.be/tfanOE2ARho)

## Code Examples

 - Lecture #1: [English Auction](code/week01)

## Exercises

- Week #1

  - Clone
    - this repository, and the
    - [The Plutus-Apps repository](https://github.com/input-output-hk/plutus-apps)
      - check out the commit specified in
        [code/week01/cabal.project](code/week01/cabal.project) (It's
        specified as `tag` for the plutus-apps
        source-repository-package)
  - Set up NixOS
    - Install NixOS cross-referencing the following resources.
       - https://nixos.org/download.html
       - https://docs.plutus-community.com
       - A few resources to understand the what and why regarding NixOS
         - https://nixos.org/manual/nix/stable
         - https://serokell.io/blog/what-is-nix
    - Set-up IOHK binary caches [How to set up the IOHK binary
      caches](https://github.com/input-output-hk/plutus#iohk-binary-cache). "If
      you do not do this, you will end up building GHC, which takes
      several hours. If you find yourself building GHC, *stop* and fix
      the cache."
  - Run Plutus Playground:
    - Enter a `nix-shell` from the `plutus-apps` repository
    - Go to the `plutus-playground-client` and start playground server
      by executing `plutus-playground-server`
    - Enter another `nix-shell` from `plutus-apps` folder, cd to
      `plutus-playground-client` and start Playground client with `npm
      start`.
    - you should now have the Plutus Playground web app running on
      https://localhost:8009/

  - Simulate the English auction:
    - From this repository copy-paste [EnglishAuction.hs code](/code/week01/src/Week01/EnglishAuction.hs) into the
      playground web app and click "compile"
    - Simulate various auction scenarios as shown in the video

  You can also verify if you can compile the English Auction code by
  - starting another `nix-shell` from the `plutus-apps` repository, then
  - going to the [English Auction folder](code/week01) in this
    repository and running `cabal build` (you may need to run `cabal update` first).

## Some Plutus Modules

## Additional Resources

- [The Plutus repository](https://github.com/input-output-hk/plutus)
- [The Plutus-Apps repository](https://github.com/input-output-hk/plutus-apps)
- Learn You a Haskell for Great Good: [original](http://learnyouahaskell.com/),
  [remastered](https://hansruec.github.io/learn-you-a-haskell-remastered/01-first-things-first.html) and
  [interactive notebook](https://hub.gke2.mybinder.org/user/jamesdbrock-lea-askell-notebook-24dgdx7w/lab/tree/learn_you_a_haskell/00-preface.ipynb)
- [Haskell & Cryptocurrencies course Mongolia](https://www.youtube.com/playlist?list=PLJ3w5xyG4JWmBVIigNBytJhvSSfZZzfTm)
