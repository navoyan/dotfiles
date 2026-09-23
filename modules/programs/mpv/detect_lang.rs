#!/usr/bin/env rust-script

//! ```cargo
//! [dependencies]
//! lingua = "1.8"
//! ```

use lingua::LanguageDetectorBuilder;
use std::env;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let text = env::args()
        .nth(1)
        .ok_or("single 'text' argument is required")?;

    let detector = LanguageDetectorBuilder::from_all_spoken_languages().build();

    let lang = detector
        .detect_language_of(text)
        .ok_or("undetectable language")?;

    print!("{}", lang.iso_code_639_1());
    Ok(())
}
