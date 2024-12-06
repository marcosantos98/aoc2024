package day6

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strings"

import "core:testing"

parse_puzzle_input :: proc(filename: string) -> ([][]u8, [2]int) {

	content, ok := os.read_entire_file(filename)
	str := string(content[:])
	defer delete(str)

	lines := strings.split(str, "\n", context.temp_allocator)

	rows := make([][]u8, len(lines), context.temp_allocator)
	gp := [2]int{}

	for l, idx in lines {
		rows[idx] = make([]u8, len(l), context.temp_allocator)
		for c, idxc in l {
			rows[idx][idxc] = cast(u8)c
			if c == '^' {
				gp[0] = idx
				gp[1] = idxc
			}
		}
	}


	return rows[:], gp
}

solve_part_1 :: proc(filename: string) -> int {

	mapp, gp := parse_puzzle_input(filename)
	mapp[gp[0]][gp[1]] = '.'

	in_bounds := proc(guard: [2]int, mapp: [][]u8) -> bool {
		return guard.x < len(mapp[0]) && guard.y < len(mapp) - 1 && guard.x >= 0 && guard.y >= 0
	}

	directions := [4][2]int{{0, -1}, {1, 0}, {0, 1}, {-1, 0}}
	Seen :: struct {
		x, y: int,
	}

	seen := make([dynamic]Seen, context.temp_allocator)

	h := len(mapp) - 1
	w := len(mapp[0])
	dir := 0
	guard := gp.yx

	x, y := guard.x, guard.y
	for true {
		if !slice.contains(seen[:], Seen{x, y}) {
			append(&seen, Seen{x, y})
		}

		nx := x + directions[dir].x
		ny := y + directions[dir].y

		if !in_bounds({nx, ny}, mapp) {
			break
		}

		if mapp[ny][nx] == '#' {
			dir = (dir + 1) % 4
		} else {
			x = nx
			y = ny
		}
	}

	return len(seen)
}

solve_part_2 :: proc(filename: string) -> int {

	mapp, gp := parse_puzzle_input(filename)
	mapp[gp[0]][gp[1]] = '.'

	in_bounds := proc(guard: [2]int, mapp: [][]u8) -> bool {
		return guard.x < len(mapp[0]) && guard.y < len(mapp) - 1 && guard.x >= 0 && guard.y >= 0
	}

	directions := [4][2]int{{0, -1}, {1, 0}, {0, 1}, {-1, 0}}

	res := 0
	max_steps := len(mapp) - 1
	for y in 0 ..< len(mapp) - 1 {
		for x in 0 ..< len(mapp[0]) {
			if mapp[y][x] == '.' && !(x == gp.x && y == gp.y) {
				mapp[y][x] = '#'

				guard_pos := gp.yx
				dir := 0
				steps := 0
				for true {
					new_pos := guard_pos + directions[dir]

					if !in_bounds(new_pos, mapp) {
						break
					}

					if mapp[new_pos.y][new_pos.x] == '#' {
						dir = (dir + 1) % 4
					} else {
						guard_pos = new_pos
					}
					if steps == max_steps * max_steps {
						res += 1
						break
					} else {
						steps += 1
					}
				}

				mapp[y][x] = '.'
			}
		}
	}


	return res
}

main :: proc() {
	fmt.println("Part 1:", solve_part_1("./puzzle_1.txt"))
	fmt.println("Part 2:", solve_part_2("./puzzle_1.txt"))
}

@(test)
day_06_part_1 :: proc(t: ^testing.T) {
	test_1 := solve_part_1("./06/test_1.txt")
	testing.expectf(t, test_1 == 41, "Expected 41 but got {}", test_1)
}

@(test)
day_06_part_2 :: proc(t: ^testing.T) {
	test_2 := solve_part_2("./06/test_1.txt")
	testing.expectf(t, test_2 == 6, "Expected 6 but got {}", test_2)
}
