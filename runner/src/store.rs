use md5;
use once_cell::sync::Lazy;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::fs;
use std::path::Path;
use std::sync::Mutex;

#[derive(Serialize, Deserialize)]
enum SolutionMetadata {
    AnswerHash(String),
}

type SolutionKey = (u16, u8, String, u8);

type Store = HashMap<SolutionKey, SolutionMetadata>;

static STORE: Lazy<Mutex<Store>> = Lazy::new(|| {
    let path = Path::new("metadata");
    if path.exists() {
        let bytes = fs::read(path).unwrap_or_default();
        bincode::deserialize(&bytes).unwrap_or_default()
    } else {
        HashMap::new()
    }
    .into()
});

pub fn is_correct_answer(year: u16, day: u8, input: &str, part: u8, guess: &str) -> Option<bool> {
    let guess_hash = format!("{:x}", md5::compute(guess));
    STORE
        .lock()
        .unwrap()
        .get(&(year, day, input.to_owned(), part))
        .and_then(|meta| match meta {
            SolutionMetadata::AnswerHash(s) => Some(s == &guess_hash),
        })
}

pub fn save_answer(year: u16, day: u8, input: &str, part: u8, answer: &str) {
    let answer_hash = format!("{:x}", md5::compute(answer));
    let mut map = STORE.lock().unwrap();
    map.insert(
        (year, day, input.to_owned(), part),
        SolutionMetadata::AnswerHash(answer_hash),
    );
    let bytes = bincode::serialize(&*map).unwrap();
    let _ = fs::write("metadata", bytes);
}
