# Advent of Code

My solutions for the [Advent of Code](https://adventofcode.com).

## Usage

Populate a local `.env` file with your session cookie to support fetching inputs and submitting answers via CLI:

```bash
AOC_SESSION="your_session_cookie_here"
```

### Creating and Running Solutions

```bash
./aoc new 2024 1 rust       # Create a new solution based on a language template
                            # (or omit the language to choose randomly)

./aoc run                   # Run the current solution
./aoc run 2                 # Run part 2

./aoc add example 35        # Add example input with an optional known output
./aoc run example 2         # Run against the example input for part 2
```

### Other Commands

```bash
./aoc set 2024 5 python     # Set the current year, day, and language context
./aoc clear                 # Clear the current context
./aoc fetch                 # Download the input for the current day
./aoc used 2024             # Show languages used for a given year
./aoc unused 2024           # Show languages not yet used for a given year
```

## Directory Structure

Solutions are organized by year, day, and language:

```
2024/
├── 01/
│   └── lolcode/
│       ├── solution.lol
│       └── inputs/        # (gitignored) official and example inputs
├── 02/
│   └── rust/
│       ├── Cargo.toml
│       ├── src/
│       └── inputs/
...
```

Each solution directory contains the implementation and an `inputs/` folder (gitignored) for official puzzle inputs and any example inputs you add.

## Automatic Solution Checking / Submission

The runner captures the last line written to STDOUT as the answer and provides feedback accordingly:

```bash
./aoc run
# 12345
# ✅ Correct answer!

./aoc run example
# abcde
# Do you want to save this solution? [y/N]: y
# Example answer saved.

./aoc run example
# bad output
# ❌ Incorrect answer. Expected: abcde

./aoc run 2
# 12000
# Do you want to submit this answer? [y/N]: y
# ⬆️  Answer is too low.

./aoc run 2
# 12345
# Do you want to submit this answer? [y/N]: y
# ✅ Correct answer submitted!
```

## Containerization

All solutions run inside a unified Docker container with Nix devshells. This ensures reproducible environments across 68 supported languages without polluting your local system.

The infrastructure lives in `infra/`:
- **Dockerfile** - NixOS-based container with flakes enabled
- **flake.nix** - Defines devshells for each language
- **languages.toml** - Language definitions with packages and run commands
- **customLangs.nix** - Custom derivations for languages requiring special handling

When you run a solution, the CLI mounts the solution directory into the container and executes it within the appropriate Nix devshell.

## Language Templates

Each language has a template in `languages/<lang>/` that provides a scaffold accepting an input file and part argument. Templates output the line count and part number as a basic verification that I/O is working.

Supported languages include:
Ada, Arturo, Ballerina, Bash, Borgo, C, Clojure, COBOL, Crystal, D, Dart, Elixir, Erlang, Forth, Fortran, F#, Gleam, Go, Groovy, Hare, Haskell, Haxe, Idris 2, INTERCAL, Io, Janet, Java, Julia, Koka, Kotlin, Lobster, LOLCODE, Lua, Mercury, MiniScript, MoonScript, Nim, Nix, Node.js, OCaml, Odin, Pascal, Perl, PHP, Pony, Prolog, Python, QBasic, R, Racket, Raku, Red, Roc, Ruby, Rust, Scala, Shakespeare, Smalltalk, SQL, Swift, Tcl, TypeScript, Uiua, Unison, V, Wren, YASL, and Zig.

For languages requiring build infrastructure or special handling, the template may include additional configuration files or a `run.sh` wrapper script.
