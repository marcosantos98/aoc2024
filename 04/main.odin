package day4

import "core:fmt"
import "core:mem"
import "core:os"
import "core:strings"

import "core:testing"

parse_puzzle_input :: proc(filename: string) -> [][]u8 {
	content, err := os.read_entire_file(filename)

	str := string(content[:])
	defer delete(str)

	lines := strings.split(str, "\n")
	defer delete(lines)

	h := len(lines)
	w := len(lines[0])

	res := make([][]u8, h)
	for i in 0 ..< h {
		res[i] = make([]u8, w)
	}

	for y in 0 ..< h - 1 {
		for x in 0 ..< w {
			res[y][x] = lines[y][x]
		}
	}


	return res[:]
}

solve_part_1 :: proc(filename: string) -> int {
	data := parse_puzzle_input(filename)
	defer for y in data {
		delete(y)
	}
	defer delete(data)

	h := len(data)
	w := len(data[0])

	found := 0

	for y in 0 ..< h {
		for x in 0 ..< w {
			it := data[y][x]
			if it == 'X' {
				// horizontal
				if x + 3 < w &&
				   data[y][x + 1] == 'M' &&
				   data[y][x + 2] == 'A' &&
				   data[y][x + 3] == 'S' {
					found += 1
				}
				// vertical
				if y + 3 <= h &&
				   data[y + 1][x] == 'M' &&
				   data[y + 2][x] == 'A' &&
				   data[y + 3][x] == 'S' {
					found += 1
				}
				// left diag
				if x - 3 >= 0 &&
				   y + 3 <= h &&
				   data[y + 1][x - 1] == 'M' &&
				   data[y + 2][x - 2] == 'A' &&
				   data[y + 3][x - 3] == 'S' {
					found += 1
				}
				// right diag
				if x + 3 < w &&
				   y + 3 <= h &&
				   data[y + 1][x + 1] == 'M' &&
				   data[y + 2][x + 2] == 'A' &&
				   data[y + 3][x + 3] == 'S' {
					found += 1
				}
			} else if it == 'S' {
				// horizontal
				if x + 3 < w &&
				   data[y][x + 1] == 'A' &&
				   data[y][x + 2] == 'M' &&
				   data[y][x + 3] == 'X' {
					found += 1
				}
				// vertical
				if y + 3 <= h &&
				   data[y + 1][x] == 'A' &&
				   data[y + 2][x] == 'M' &&
				   data[y + 3][x] == 'X' {
					found += 1
				}
				// left diag
				if x - 3 >= 0 &&
				   y + 3 <= h &&
				   data[y + 1][x - 1] == 'A' &&
				   data[y + 2][x - 2] == 'M' &&
				   data[y + 3][x - 3] == 'X' {
					found += 1
				}
				// right diag
				if x + 3 < w &&
				   y + 3 <= h &&
				   data[y + 1][x + 1] == 'A' &&
				   data[y + 2][x + 2] == 'M' &&
				   data[y + 3][x + 3] == 'X' {
					found += 1
				}
			}
		}
	}

	return found
}

solve_part_2 :: proc(filename: string) -> int {
	data := parse_puzzle_input(filename)
	defer for y in data {
		delete(y)
	}
	defer delete(data)

	h := len(data)
	w := len(data[0])

	found := 0

	is_r_mas :: proc(x, y, h, w: int, data: [][]u8) -> bool {
		return(
			x + 2 < w &&
			y + 2 <= h &&
			data[y][x] == 'M' &&
			data[y + 1][x + 1] == 'A' &&
			data[y + 2][x + 2] == 'S' \
		)
	}

	is_l_mas :: proc(x, y, h, w: int, data: [][]u8) -> bool {
		return(
			x - 2 >= 0 &&
			y + 2 <= h &&
			data[y][x] == 'M' &&
			data[y + 1][x - 1] == 'A' &&
			data[y + 2][x - 2] == 'S' \
		)
	}

	is_r_sam :: proc(x, y, h, w: int, data: [][]u8) -> bool {
		return(
			x + 2 < w &&
			y + 2 <= h &&
			data[y][x] == 'S' &&
			data[y + 1][x + 1] == 'A' &&
			data[y + 2][x + 2] == 'M' \
		)
	}

	is_l_sam :: proc(x, y, h, w: int, data: [][]u8) -> bool {
		return(
			x - 2 >= 0 &&
			y + 2 <= h &&
			data[y][x] == 'S' &&
			data[y + 1][x - 1] == 'A' &&
			data[y + 2][x - 2] == 'M' \
		)
	}

	for y in 0 ..< h {
		for x in 0 ..< w {
			it := data[y][x]
			if it == 'M' {
				if is_r_mas(x, y, h, w, data) &&
				   (is_l_sam(x + 2, y, h, w, data) || is_l_mas(x + 2, y, h, w, data)) {
					found += 1
				}
			} else if it == 'S' {
				if is_r_sam(x, y, h, w, data) &&
				   (is_l_mas(x + 2, y, h, w, data) || is_l_sam(x + 2, y, h, w, data)) {
					found += 1
				}
			}
		}
	}

	return found
}

main :: proc() {
	fmt.println("Part 1:", solve_part_1("./puzzle_1.txt"))
	fmt.println("Part 2:", solve_part_2("./puzzle_1.txt"))
}

@(test)
day_04_part_1 :: proc(t: ^testing.T) {
	test_1 := solve_part_1("./04/test_1.txt")
	testing.expectf(t, test_1 == 18, "Expected 18 but got {}", test_1)
}

@(test)
day_04_part_2 :: proc(t: ^testing.T) {
	test_2 := solve_part_2("./04/test_1.txt")
	testing.expectf(t, test_2 == 9, "Expected 9 but got {}", test_2)
}
