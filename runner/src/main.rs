use clap::{Parser, Subcommand, ValueHint};
use dotenv::dotenv;
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
    #[command(
        about = "Add an example input for the current puzzle, optionally with expected answers"
    )]
    Add {
        example_name: String,
        part1_answer: Option<String>,
        part2_answer: Option<String>,
    },

    #[command(about = "Clear the year, day, and language settings")]
    Clear,

    Demo,

    #[command(about = "Download the input for the current day")]
    Fetch {
        year: Option<usize>,
        day: Option<usize>,
    },

    #[command(about = "Create a new solution directory")]
    New {
        year: usize,
        day: usize,
        language: Option<String>,

        #[arg(short = 'y', long = "yes")]
        yes: bool,
    },

    #[command(about = "Rebuild the aoc binary")]
    Rebuild {
        #[arg(short = 'f', long = "full")]
        full: bool,
    },

    #[command(
        about = "Run a solution for the current day, optionally for a specific input and part"
    )]
    Run {
        example_name: Option<String>,
        part: Option<usize>,

        #[arg(short = 'y', long = "yes", conflicts_with = "no")]
        yes: bool,

        #[arg(short = 'n', long = "no", conflicts_with = "yes")]
        no: bool,
    },

    #[command(about = "Save a solution to the current day's solutions file")]
    Save {
        #[arg(
            help = "Arguments: [example] [part] <answer>",
            value_hint = ValueHint::Other,
            trailing_var_arg = true
        )]
        args: Vec<String>,
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

    #[command(about = "Run tests on the aoc binary, optionally for a given language")]
    Test {
        language: Option<String>,
    },

    #[command(
        about = "Show supported languages that have not been used, optionally filtered by year"
    )]
    Unused {
        year: Option<usize>,
    },

    #[command(about = "Show supported languages that have been used, optionally filtered by year")]
    Used {
        year: Option<usize>,
    },
}

fn main() {
    dotenv().ok();
    let cli = Cli::parse();

    match &cli.command {
        Commands::Add {
            example_name,
            part1_answer,
            part2_answer,
        } => commands::add::run(example_name, part1_answer, part2_answer),
        Commands::Fetch { year, day } => commands::fetch::run(year, day),
        Commands::Demo => commands::demo::run(),
        Commands::New {
            year,
            day,
            language,
            yes,
        } => commands::new::run(*year, *day, language, yes),
        Commands::Rebuild { full } => commands::rebuild::run(*full),
        Commands::Clear => commands::clear::run(),
        Commands::Run {
            example_name,
            part,
            yes,
            no,
        } => {
            let confirmation = match (yes, no) {
                (true, false) => Some(true),
                (false, true) => Some(false),
                _ => None,
            };
            let (resolved_example_name, resolved_part) = parse_run_args(example_name, part);
            commands::run::run(resolved_example_name, resolved_part, confirmation);
        }
        Commands::Save { args } => {
            let (example_name, part, answer) = parse_save_args(args);
            commands::save::run(example_name, part, answer);
        }
        Commands::Set {
            year,
            day,
            language,
        } => commands::set::run(*year, *day, language),
        Commands::Test { language } => commands::test::run(language),
        Commands::Unused { year } => commands::unused::run(year),
        Commands::Used { year } => commands::used::run(year),
    }
}

fn parse_save_args(args: &Vec<String>) -> (Option<String>, Option<usize>, String) {
    let mut example_name = None;
    let mut part = None;
    let answer;

    match args.len() {
        1 => {
            answer = args[0].clone();
        }
        2 => {
            if let Ok(parsed_part) = args[0].parse::<usize>() {
                part = Some(parsed_part);
                answer = args[1].clone();
            } else {
                example_name = Some(args[0].clone());
                answer = args[1].clone();
            }
        }
        3 => {
            example_name = Some(args[0].clone());
            part = args[1].parse::<usize>().ok();
            answer = args[2].clone();
        }
        _ => {
            eprintln!("Error: Incorrect number of arguments provided to save command.");
            std::process::exit(1);
        }
    }

    (example_name, part, answer)
}

fn parse_run_args(
    example_name: &Option<String>,
    part: &Option<usize>,
) -> (Option<String>, Option<usize>) {
    if let Some(example_name) = example_name {
        if let Ok(parsed_part) = example_name.parse::<usize>() {
            return (None, Some(parsed_part));
        }
    }
    (example_name.clone(), part.clone())
}
