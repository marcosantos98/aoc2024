package day2

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

import "core:testing"

parse_puzzle_input :: proc(filename: string) -> [][dynamic]int {
	content, err := os.read_entire_file(filename)

	str := string(content[:])
	defer delete(str)

	lines := strings.split(str, "\n")
	defer delete(lines)

	res := make([dynamic][dynamic]int)

	for l in lines {
		if l == "" {continue}
		vals := strings.split(l, " ")
		defer delete(vals)
		levels := make([dynamic]int)
		for val, idx in vals {
			append(&levels, strconv.atoi(val))
		}
		append(&res, levels)
	}

	return res[:]
}

safe_report :: proc(values: []int) -> bool {
	is_increasing := slice.is_sorted_by(values, proc(a, b: int) -> bool {
		return a < b
	})
	is_decreasing := slice.is_sorted_by(values, proc(a, b: int) -> bool {
		return a > b
	})

	if !is_increasing && !is_decreasing {return false}

	for i := 0; i + 1 < len(values); i += 1 {
		if abs(values[i] - values[i + 1]) > 3 || abs(values[i] - values[i + 1]) == 0 {
			return false
		}
	}

	return is_increasing || is_decreasing
}

solve_part_1 :: proc(filename: string) -> int {
	report := parse_puzzle_input(filename)
	defer {
		for l in report {
			delete(l)
		}
		delete(report)
	}

	safe_cases := 0
	for level in report {
		if safe_report(level[:]) {safe_cases += 1}
	}

	return safe_cases
}

solve_part_2 :: proc(filename: string) -> int {
	report := parse_puzzle_input(filename)
	defer {
		for l in report {
			delete(l)
		}
		delete(report)
	}

	safe_cases := 0
	for level in report {
		for i := 0; i < len(level); i += 1 {
			values := slice.clone_to_dynamic(level[:])
			defer delete(values)
			ordered_remove(&values, i)
			if safe_report(values[:]) {
				safe_cases += 1
				break
			}
		}

	}

	return safe_cases
}


main :: proc() {
	fmt.println("Part 1:", solve_part_1("./02/puzzle_1.txt"))
	fmt.println("Part 2:", solve_part_2("./02/puzzle_1.txt"))
}

@(test)
day_02_part_1 :: proc(t: ^testing.T) {
	test_1 := solve_part_1("./02/test_1.txt")
	testing.expectf(t, test_1 == 2, "Expect 2 got {}", test_1)
}

@(test)
day_02_part_2 :: proc(t: ^testing.T) {
	test_2 := solve_part_2("./02/test_1.txt")
	testing.expectf(t, test_2 == 4, "Expect 4 got {}", test_2)
}
