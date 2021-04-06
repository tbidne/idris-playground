# Idris Playground

<p>
    <a href="https://github.com/tbidne/idris-playground/workflows/build/badge.svg?branch=main" alt="build">
        <img src="https://img.shields.io/github/workflow/status/tbidne/idris-playground/build/main?style=plastic" height="20"/>
    </a>
</p>

Just a repository that demos `Idris` with `nix`.

## Nix Shell

```shell
nix-shell
```

## Building

```shell
idris2 ./src/Main.idr --source-dir ./src -o idris-pg
```

## Running

```shell
./build/exec/idris-pg
```