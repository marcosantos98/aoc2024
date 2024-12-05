package day5

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

import "core:testing"

Rule :: struct {
	a, b: int,
}

parse_puzzle_input :: proc(filename: string) -> ([]Rule, [][]int) {
	content, ok := os.read_entire_file(filename)

	str := string(content[:])
	defer delete(str)

	lines := strings.split_lines(str, context.temp_allocator)

	rules := make([dynamic]Rule)
	page_order := make([dynamic][]int)
	is_rule_section := true
	for l in lines {
		if is_rule_section {
			rule_pair := strings.split(l, "|", context.temp_allocator)
			if len(rule_pair) != 2 && l == "" {
				is_rule_section = false
			} else {
				append(&rules, Rule{strconv.atoi(rule_pair[0]), strconv.atoi(rule_pair[1])})
			}
		} else {
			if l == "" {continue}
			pages := strings.split(l, ",", context.temp_allocator)
			page := make([]int, len(pages), context.temp_allocator)
			for p, idx in pages {
				page[idx] = strconv.atoi(p)
			}
			append(&page_order, page)
		}
	}


	return rules[:], page_order[:]
}

solve_part_1 :: proc(filename: string) -> int {

	rules, page_order := parse_puzzle_input(filename)
	defer {
		delete(rules)
		delete(page_order)
	}

	sum := 0

	for page, idx in page_order {
		in_order := true
		for rule in rules {
			idx, has := slice.linear_search(page, rule.a)
			idx_b, has_b := slice.linear_search(page, rule.b)
			if has && !has_b && idx == len(page) - 1 {
				continue
			}
			if (has && has_b && idx > idx_b) {
				in_order = false
				break
			}
		}
		if in_order {
			sum += page[len(page) / 2]
		}
	}
	return sum
}

solve_part_2 :: proc(filename: string) -> int {
	rules, page_order := parse_puzzle_input(filename)
	defer {
		delete(rules)
		delete(page_order)
	}

	sum := 0

	for page, idx in page_order {
		in_order := true
		for rule in rules {
			idx, has := slice.linear_search(page, rule.a)
			idx_b, has_b := slice.linear_search(page, rule.b)
			if has && !has_b && idx == len(page) - 1 {
				continue
			}
			if (has && has_b && idx > idx_b) {
				in_order = false
				break
			}
		}
		ok := in_order
		for !ok {
			ok = true
			for rule in rules {
				idx, has := slice.linear_search(page, rule.a)
				idx_b, has_b := slice.linear_search(page, rule.b)
				if (has && has_b && idx > idx_b) {
					ok = false
					slice.swap(page, idx, idx_b)
				}
			}
		}
		if ok && !in_order {
			sum += page[len(page) / 2]
		}
	}

	return sum
}

main :: proc() {
	fmt.println("Part 1:", solve_part_1("./puzzle_1.txt"))
	fmt.println("Part 2:", solve_part_2("./puzzle_1.txt"))
}

@(test)
day_05_part_1 :: proc(t: ^testing.T) {
	test_1 := solve_part_1("./05/test_1.txt")
	testing.expectf(t, test_1 == 143, "Expected 143 but got {}", test_1)
	puzzle := solve_part_1("./05/puzzle_1.txt")
	testing.expectf(t, puzzle == 4637, "Expected 4637 but got {}", puzzle)
}

@(test)
day_05_part_2 :: proc(t: ^testing.T) {
	test_2 := solve_part_2("./05/test_1.txt")
	testing.expectf(t, test_2 == 123, "Expected 123 but got {}", test_2)
	puzzle := solve_part_2("./05/puzzle_1.txt")
	testing.expectf(t, puzzle == 6370, "Expected 6370 but got {}", puzzle)
}
