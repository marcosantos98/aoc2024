package day3

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

import "core:testing"

is_digit := proc(c: u8) -> bool {
	return c >= 48 && c <= 57
}

parse_puzzle_input :: proc(filename: string, conditional: bool) -> int {

	content, ok := os.read_entire_file(filename)

	str := string(content[:])
	defer delete(str)

	cursor := 0

	parse_number := proc(cursor: ^int, str: string) -> (int, bool) {
		start := cursor^
		for is_digit(str[cursor^]) && cursor^ < len(str) {
			cursor^ += 1
		}

		return strconv.atoi(string(str[start:cursor^])), cursor^ - start <= 3
	}

	sum := 0

	is_enabled := true

	for cursor < len(str) {
		if conditional {
			if strings.starts_with(str[cursor:], "don't()") {
				is_enabled = false
				cursor += 7
			}

			if strings.starts_with(str[cursor:], "do()") {
				is_enabled = true
				cursor += 4
			}
		}

		if is_enabled && strings.starts_with(str[cursor:], "mul(") {
			cursor += 4
			if !is_digit(str[cursor]) {continue}
			a, a_valid := parse_number(&cursor, str)
			if !a_valid || str[cursor] != ',' {continue}
			cursor += 1
			b, b_valid := parse_number(&cursor, str)
			if !b_valid || str[cursor] != ')' {continue}
			sum += a * b
		} else {
			cursor += 1
		}
	}

	return sum
}

main :: proc() {
	fmt.println("Part 1:", parse_puzzle_input("./puzzle_1.txt", false))
	fmt.println("Part 2:", parse_puzzle_input("./puzzle_1.txt", true))
}

@(test)
day_03_part_1 :: proc(t: ^testing.T) {
	test_1 := parse_puzzle_input("./03/test_1.txt", false)
	testing.expectf(t, test_1 == 161, "Expect 161 but got {}", test_1)
}

@(test)
day_03_part_2 :: proc(t: ^testing.T) {
	test_2 := parse_puzzle_input("./03/test_2.txt", true)
	testing.expectf(t, test_2 == 48, "Expect 48 but got {}", test_2)
}
