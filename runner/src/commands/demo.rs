use crossterm::{cursor, execute, event, terminal};
use std::io::{self, BufRead, Write};
use std::process::{Command, Stdio};
use std::sync::mpsc;
use std::thread;
use std::time::{Duration, Instant};

pub fn run() {
    terminal::enable_raw_mode().expect("Failed to enable raw mode");

    // Start the timer thread to display elapsed time at the bottom
    let start_time = Instant::now();
    let timer_handle = thread::spawn(move || {
        loop {
            let elapsed = start_time.elapsed();
            print_timer(elapsed);
            thread::sleep(Duration::from_millis(100));
        }
    });

    // Run the first counting process, outputting above the timer
    println!("Starting first count to 10:");
    run_counting_process(10);

    clear_timer_display();
    // Prompt for single keypress (y/n)
    println!("\nDo you want to continue to the next count? (y/n)");
    print_timer(Instant::now().elapsed());
    match wait_for_keypress().unwrap() {
        'y' => {
            clear_timer_display();
            println!("\nContinuing...");
            run_counting_process(10); // Run the second counting process to 10
        }
        'n' => {
            clear_timer_display();
            println!("\nExiting...");
        },
        _ => {
            clear_timer_display();
            println!("\nInvalid key pressed. Exiting...");
        }
    }

    // Stop the timer and clear it
    drop(timer_handle);
    clear_timer_display();

    terminal::disable_raw_mode().expect("Failed to disable raw mode");
}

// Run a process that counts to `max`, handling both stdout and stderr
fn run_counting_process(max: usize) {
    let mut child = Command::new("sh")
        .arg("-c")
        .arg(format!("for i in $(seq 1 {}); do echo $i; sleep 1; done; echo 'error' 1>&2", max))
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .expect("Failed to start counting process");

    let stdout = child.stdout.take().expect("Failed to capture stdout");
    let stderr = child.stderr.take().expect("Failed to capture stderr");

    // Use a channel to collect both stdout and stderr messages
    let (sender, receiver) = mpsc::channel();

    // Spawn thread to read stdout
    let stdout_sender = sender.clone();
    let stdout_handle = thread::spawn(move || {
        let reader = io::BufReader::new(stdout);
        for line in reader.lines() {
            let line = line.unwrap();
            stdout_sender.send(("stdout", line)).unwrap();
        }
    });

    // Spawn thread to read stderr
    let stderr_sender = sender.clone();
    let stderr_handle = thread::spawn(move || {
        let reader = io::BufReader::new(stderr);
        for line in reader.lines() {
            let line = line.unwrap();
            stderr_sender.send(("stderr", line)).unwrap();
        }
    });

    // Collect and print each line in the order received
    drop(sender); // Close the sender channel to signal end of input
    for (stream, line) in receiver {
        clear_timer_display();
        match stream {
            "stdout" => println!("{}", line),
            "stderr" => eprintln!("stderr: {}", line),
            _ => (),
        }
        print_timer(Instant::now().elapsed());
    }

    // Wait for both stdout and stderr threads to finish
    let _ = stdout_handle.join();
    let _ = stderr_handle.join();

    // Wait for the child process to complete
    let _ = child.wait();
}

fn wait_for_keypress() -> Result<char, io::Error> {
    loop {
        if event::poll(Duration::from_secs(1))? {
            if let event::Event::Key(key_event) = event::read()? {
                match key_event.code {
                    event::KeyCode::Char(c) => return Ok(c),
                    _ => continue,
                }
            }
        }
    }
}

fn print_timer(elapsed: Duration) {
    execute!(
        io::stdout(),
        cursor::MoveToColumn(0),
        terminal::Clear(terminal::ClearType::CurrentLine)
    )
    .unwrap();
    print!("Elapsed time: {:.2?}", elapsed);
    io::stdout().flush().unwrap();
}

fn clear_timer_display() {
    execute!(
        io::stdout(),
        cursor::MoveToColumn(0),
        terminal::Clear(terminal::ClearType::CurrentLine)
    )
    .unwrap();
}
