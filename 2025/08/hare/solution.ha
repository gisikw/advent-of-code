use fmt;
use os;
use bufio;
use io;
use strings;
use strconv;
use math;
use sort;

type junction = struct { x: int, y: int, z: int };
type edge = struct { a: junction, b: junction, length: f64 };
type circuit = struct { boxes: []junction };

fn mkEdge(a: junction, b: junction) edge = {
	return edge {
		length = math::sqrtf64(
			math::powf64((b.x - a.x): f64, 2.0) + 
			math::powf64((b.y - a.y): f64, 2.0) + 
			math::powf64((b.z - a.z): f64, 2.0)
		),
		a = a,
		b = b
	};
};

fn cmpEdge(a: const *opaque, b: const *opaque) int = {
	const a = *(a: const *edge), b = *(b: const *edge);
	return if (a.length < b.length) -1
		else if (a.length > b.length) 1
		else 0;
};

fn cmpCircuit(a: const *opaque, b: const *opaque) int = {
	const a = *(a: const *circuit), b = *(b: const *circuit);
	return if (len(a.boxes) < len(a.boxes)) 1
		else if (len(a.boxes) > len(b.boxes )) -1
		else 0;
};

fn junctionEqual(a: junction, b: junction) bool = {
	return a.x == b.x && a.y == b.y && a.z == b.z;
};

fn upsertJunction(c: *circuit, junc: junction) void = {
	for (let i = 0z; i < len(c.boxes); i += 1) {
		if (junctionEqual(c.boxes[i], junc)) return;
	};
	append(c.boxes, junc);
};

fn junctionIndex(all: []junction, junc: junction) size = {
	let i = 0z;
	for (i < len(all); i += 1) {
		if (junctionEqual(all[i], junc)) {
			break;
		};
	};
	return i;
};

export fn main() void = {
	const file = os::open(os::args[1])!;
	const part = strconv::stoi(os::args[2])!;
	defer io::close(file)!;

	let boxes: []junction = [];
	let edges: []edge = [];
	let circuits: []circuit = [];

	let lines = 0;
	for (true) {
		const line = match (bufio::read_line(file)) {
		case let line: []u8 =>
			yield line;
		case io::EOF =>
			break;
		};
		const linestr = strings::fromutf8(line)!;
		const coords = strings::tokenize(linestr, ",");
		append(boxes, junction {
			x = strconv::stoi(strings::next_token(&coords) as str)!,
			y = strconv::stoi(strings::next_token(&coords) as str)!,
			z = strconv::stoi(strings::next_token(&coords) as str)!
		});
	};

	for (let i = 0z; i < len(boxes); i += 1) {
		let j = i + 1;
		for (j < len(boxes); j += 1) {
			append(edges, mkEdge(boxes[i], boxes[j]));
		};
	};

	sort::sort(edges, size(edge), &cmpEdge);

	if (part == 1) {
		for (let i = len(edges) - 1; i >= 1000z; i -= 1) delete(edges[i]);

		for (len(edges) > 0) {
			let circ = circuit {
				boxes = alloc([ edges[0].a, edges[0].b ])
			};
			delete(edges[0]);

			for (let i = 0z; i < len(circ.boxes); i += 1) for (let j = 0z; j < len(edges); j += 1) {
				if (junctionEqual(circ.boxes[i], edges[j].a) || junctionEqual(circ.boxes[i], edges[j].b)) {
					upsertJunction(&circ, edges[j].a);
					upsertJunction(&circ, edges[j].b);
					delete(edges[j]);
					j -= 1;
				};
			};

			append(circuits, circ);
		};

		sort::sort(circuits, size(circuit), &cmpCircuit);

		let result = 1z;
		for (let i = 0z; i < 3z; i += 1) result *= len(circuits[i].boxes);

		fmt::printfln("{}", result)!;
	} else {
		// Boy, I sure overcomplicated part 1, huh?
		let circuits: []size = [];
		for (let i = 0z; i < len(boxes); i += 1) append(circuits, i);

		let allMatch = false;
		let i = 0z;
		for (i < len(edges) && !allMatch; i += 1) {
			let aValue = circuits[junctionIndex(boxes, edges[i].a)];
			let bValue = circuits[junctionIndex(boxes, edges[i].b)];

			for (let j = 0z; j < len(circuits); j += 1) {
				if (circuits[j] == bValue) circuits[j] = aValue;
			};

			allMatch = true;
			for (let j = 1z; j < len(boxes); j += 1) {
				if (circuits[j] != circuits[0z]) {
					allMatch = false;
					break;
				};
			};
		};

		fmt::printfln("{}", edges[i-1].a.x * edges[i-1].b.x)!;
	};
};
