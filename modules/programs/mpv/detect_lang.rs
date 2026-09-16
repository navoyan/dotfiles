#!/usr/bin/env rust-script

//! ```cargo
//! [dependencies]
//! lingua = "1.8"
//! ```

use lingua::LanguageDetectorBuilder;
use std::env;

fn main() {
    let text = env::args()
        .nth(1)
        .expect("single 'text' argument is required");

    let detector = LanguageDetectorBuilder::from_all_spoken_languages().build();

    let lang = detector
        .detect_language_of(text)
        .expect("undetectable language");

    print!("{}", lang.iso_code_639_1())
}
