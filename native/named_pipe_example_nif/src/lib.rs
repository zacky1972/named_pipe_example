#[macro_use] extern crate rustler;
// #[macro_use] extern crate rustler_codegen;
#[macro_use] extern crate lazy_static;

extern crate libc;

use rustler::{NifEnv, NifTerm, NifResult, NifEncoder};
use libc::{fork, mkfifo, exit};
use std::ffi::CString;
use std::fs::File;
use std::io::prelude::*;

mod atoms {
    rustler_atoms! {
        atom ok;
        //atom error;
        //atom __true__ = "true";
        //atom __false__ = "false";
    }
}

rustler_export_nifs! {
    "Elixir.NamedPipeExampleNif",
    [("run", 2, run)],
    None
}

fn run<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let path: String = try!(args[0].decode());
    let message: String = try!(args[1].decode());

    let path_c = CString::new(path.clone()).unwrap();

    unsafe {
        mkfifo(path_c.as_ptr(), 0o666);
        println!("Rust: subprocess will be forked.");
        match fork() {
            0 => { // 子プロセス
                println!("Rust: subprocess forked.");
                println!("Rust: will File::create");
                let mut f = File::create(&path).expect("file not found");
                println!("Rust: will write_all");
                f.write_all(message.as_bytes()).expect("failed");
                println!("Rust: will exit.");
                exit(0);
            },
            _ => { // 親プロセス
                println!("Rust: parent will finished.");
                Ok((atoms::ok()).encode(env))
            },
        }
    }
}
