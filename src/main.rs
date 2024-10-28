use clap::{Parser,Subcommand};
mod commands;
mod utils;

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

    #[command(about = "Clear the year, day, and language settings")]
    Clear,

    Fetch {
        #[arg(trailing_var_arg = true)]
        extra_args: Vec<String>,
    },
    New {
        #[arg(trailing_var_arg = true)]
        extra_args: Vec<String>,
    },

    #[command(about = "Rebuild the aoc binary")]
    Rebuild,

    Run {
        #[arg(trailing_var_arg = true)]
        extra_args: Vec<String>,
    },
    Save {
        #[arg(trailing_var_arg = true)]
        extra_args: Vec<String>,
    },

    #[command(about = "Set the year, day, and language settings")]
    Set {
        #[arg(help = "The year to set (e.g. 2023)")]
        year: usize,

        #[arg(help = "The day to set (e.g. 3)")]
        day: usize,

        #[arg(help = "The language to set (e.g. rust)")]
        language: Option<String>,
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
        Commands::Clear => commands::clear::run(),
        Commands::Run { extra_args } => commands::bash::run("run", extra_args),
        Commands::Save { extra_args } => commands::bash::run("save", extra_args),
        Commands::Set { year, day, language } => commands::set::run(*year, *day, language),
        Commands::Test { extra_args } => commands::bash::run("test", extra_args),
        Commands::Unused { extra_args } => commands::bash::run("unused", extra_args),
    }
}
