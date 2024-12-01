import simplifile

pub fn get() -> String {
  let assert Ok(input) = simplifile.read("inputs/sample.txt")
  input
}
