package day1

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

import "core:testing"

parse_puzzle_input :: proc(filename: string) -> ([]int, []int) {
	content, err := os.read_entire_file(filename)

	str := string(content[:])

	lines := strings.split(str, "\n")

	a := make([dynamic]int)
	b := make([dynamic]int)

	for l in lines {
		if l == "" {continue}
		cols := strings.split(l, "   ")
		aa := strings.trim(cols[0], " ")
		bb := strings.trim(cols[1], " ")
		append(&a, strconv.atoi(aa))
		append(&b, strconv.atoi(bb))
		delete(cols)
	}

	delete(str)
	delete(lines)

	return a[:], b[:]
}

solve_part_1 :: proc(filename: string) -> int {

	a, b := parse_puzzle_input(filename)

	slice.sort(a[:])
	slice.sort(b[:])

	sum := make([]int, len(a))

	for i := 0; i < len(a); i += 1 {
		sum[i] = abs(a[i] - b[i])
	}

	res := 0
	for a in sum {
		res += a
	}

	delete(sum)
	delete(a)
	delete(b)

	return res
}

solve_part_2 :: proc(filename: string) -> int {

	a, b := parse_puzzle_input(filename)

	similarity := 0
	for aa in a {
		cnt := slice.count(b[:], aa)
		similarity += aa * cnt
	}

	delete(a)
	delete(b)

	return similarity
}

main :: proc() {
	fmt.println("Part 1:", solve_part_1("./01/puzzle_1.txt"))
	fmt.println("Part 2:", solve_part_2("./01/puzzle_1.txt"))
}

@(test)
day_1_part_1 :: proc(t: ^testing.T) {
	test_1 := solve_part_1("./01/test_1.txt")
	testing.expectf(t, test_1 == 11, "Expected 11 got {}", test_1)

}

@(test)
day_1_part_2 :: proc(t: ^testing.T) {
	test_2 := solve_part_2("./01/test_1.txt")
	testing.expectf(t, test_2 == 31, "Expected 31 got {}", test_2)
}
