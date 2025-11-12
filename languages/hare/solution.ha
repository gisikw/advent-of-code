use fmt;
use os;
use bufio;
use io;

export fn main() void = {
	const file = os::open(os::args[1])!;
	defer io::close(file)!;

	let lines = 0;
	for (true) {
		match (bufio::read_line(file)) {
		case io::EOF =>
			break;
		case =>
			lines += 1;
		};
	};

	fmt::printfln("Received {} lines of input for part {}", lines, os::args[2])!;
};
