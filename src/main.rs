use clap::{Parser,Subcommand};
mod commands;

#[derive(Parser, Debug)]
#[command(version, name = "aoc")]
#[command(about = "Advent of Code CLI", long_about = None)]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}
#[derive(Subcommand, Debug)]
enum Commands {
    Add {
        #[arg(trailing_var_arg = true)]
        extra_args: Vec<String>,
    },
    Fetch {
        #[arg(trailing_var_arg = true)]
        extra_args: Vec<String>,
    },
    New {
        #[arg(trailing_var_arg = true)]
        extra_args: Vec<String>,
    },
    Rebuild,
    Reset {
        #[arg(trailing_var_arg = true)]
        extra_args: Vec<String>,
    },
    Run {
        #[arg(trailing_var_arg = true)]
        extra_args: Vec<String>,
    },
    Save {
        #[arg(trailing_var_arg = true)]
        extra_args: Vec<String>,
    },
    Set {
        #[arg(trailing_var_arg = true)]
        extra_args: Vec<String>,
    },
    Test {
        #[arg(trailing_var_arg = true)]
        extra_args: Vec<String>,
    },
    Unused {
        #[arg(trailing_var_arg = true)]
        extra_args: Vec<String>,
    },
}

fn main() {
    let cli = Cli::parse();

    match &cli.command {
        Commands::Add { extra_args } => commands::bash::run("add", extra_args),
        Commands::Fetch { extra_args } => commands::bash::run("fetch", extra_args),
        Commands::New { extra_args } => commands::bash::run("new", extra_args),
        Commands::Rebuild => commands::rebuild::run(),
        Commands::Reset { extra_args } => commands::bash::run("reset", extra_args),
        Commands::Run { extra_args } => commands::bash::run("run", extra_args),
        Commands::Save { extra_args } => commands::bash::run("save", extra_args),
        Commands::Set { extra_args } => commands::bash::run("set", extra_args),
        Commands::Test { extra_args } => commands::bash::run("test", extra_args),
        Commands::Unused { extra_args } => commands::bash::run("unused", extra_args),
    }
}
