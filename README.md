# Advent of Code

My solutions for the [Advent of Code](https://adventofcode.com).

# Usage
Populate a local `.env` file with your session cookie to support fetching
inputs and submitting answers via CLI.

```bash
./aoc new 2022 1 rust       # Create a new solution based on a language template
                            # (or omit the language to choose randomly)

./aoc run                   # Run the current solution in a Docker container
./aoc run 2                 # (optionally specifying which part to run)

./aoc add example 35        # Add example input with an optional known output
./aoc run example 2         # Run the current solution against the example input
```

# Automatic Solution Checking

In addition to creating ./solutions folders for the implementation, a ./problem
folder is created to hold the official inputs and any example inputs you choose
to add. The expected outputs are saved in a solutions.yml file which stores the
answer, or an md5 hash of the answer for official inputs.

The runner can reflect on the last line written to STDOUT and give feedback
acccordingly:

```bash
./aoc run
# 12345
# ✅ Correct answer!

./aoc run example
# abcde
# Would you like to save this result? Press [Y] to save, any other key to skip.
# Example answer saved.

./aoc run example
# bad output
# ❌ Incorrect answer. Expected: abcde

./aoc run 2
# 12345
# Would you like to submit this result? Press [Y] to submit, any other key to
# ✅ Correct answer submitted!
# Would you like to save this result? Press [Y] to save, any other key to skip.
# Official answer saved.
```

# Containerization

One of the goals of this project is for every solution to be containerized so
we can use multiple languages and return to these problems periodically without
having to mess around with our local environment.

The `config.yml` file has a list of supported languages with Docker image and
tags, along with a default run command, to which the input file and part
argument are applied.

The first time a solution is run, the specific docker image id is frozen via a
`.docker-image-id` file in the particular solution directory, thus ensuring the
solution can always be run in the environment for which it was built.
