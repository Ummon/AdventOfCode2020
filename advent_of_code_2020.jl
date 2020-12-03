### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 661be9a0-353b-11eb-3598-a5b5245368cb
html"""<style>
main {
	max-width: 100%;
	margin-right: 0;
}</style>
"""

# ╔═╡ f0dd4400-3313-11eb-3295-af913c2212fb
md"# Advent Of Code 2020"

# ╔═╡ 0b7b8920-3314-11eb-2cfb-7d20c0967e67
md"## Day 1"

# ╔═╡ 877b32e0-3315-11eb-0e96-650b19da693e
input_day1 = parse.(Int64, split(readline("data/day01.txt"))) |> sort

# ╔═╡ 4adcf8d0-33a8-11eb-0220-696f06894ef3
function day1_part1(input)
	for n ∈ input		
		r = searchsorted(input_day1, 2020 - n)
		if r.start ≤ r.stop
			return n * input[r.start]
		end
	end
end

# ╔═╡ 1e8e7230-33ae-11eb-0a77-035e6a4b9ba8
function day1_part2(input)
	l = length(input)
	for i ∈ 1:l		
		for j ∈ i+1:l
			v = 2020 - input[i] - input[j]
			if v ≤ 0
				break
			end
			r = searchsorted(input_day1, v)
			if r.start ≤ r.stop		
				return input[i] * input[j] * input[r.start]
			end
		end
	end
end

# ╔═╡ 7a037310-33ac-11eb-34fb-9bf552883937
md"**Result for part 1:** $(day1_part1(input_day1))"

# ╔═╡ c7dcdae0-33b1-11eb-2cab-fbc06c8ef76b
md"**Result for part 2:** $(day1_part2(input_day1))"

# ╔═╡ 5d9712b0-3472-11eb-1423-719331dfe52f
md"## Day 2"

# ╔═╡ b9144990-3473-11eb-0ba9-59f3fe6ddbc0
struct Password
	policy_range :: UnitRange
	policy_char :: Char
	p :: String
end	

# ╔═╡ bbda1c1e-347a-11eb-0e7a-756906c4c9f4
nb_of_valid_passwords_part2(passwords) =
	count(
		password ->
			(password.p[password.policy_range.start] == password.policy_char) ⊻
			(password.p[password.policy_range.stop] == password.policy_char),
		passwords
	)

# ╔═╡ 10f5ffa0-3474-11eb-2a36-d5c6f78f18c6
function parse_day2(lines)
	line_regexp = r"^(\d+)-(\d+) ([a-z]): ([a-z]+)$"
	
	function parse_line(line)
		m = match(line_regexp, line)
		Password(
			UnitRange(parse(Int, m.captures[1]), parse(Int, m.captures[2])),
			m.captures[3][1],
			m.captures[4]
		)
	end
	
	parse_line.(lines)
end

# ╔═╡ 6695038e-3472-11eb-1846-3b1c041be59d
nb_of_valid_passwords_part1(passwords) =
	count(
		password -> count(==(password.policy_char), password.p) ∈ password.policy_range,
		passwords
	)

# ╔═╡ a0cfb670-3474-11eb-1a05-c12914658a0a
let
	test1_input = 
		split("""
			1-3 a: abcde
			1-3 b: cdefg
			2-9 c: ccccccccc""",
			'\n'
		)
	
	test1_part1_result = nb_of_valid_passwords_part1(parse_day2(test1_input))	
	test1_part2_result = nb_of_valid_passwords_part2(parse_day2(test1_input))
	
	md"
Test 1, part 1: $(test1_part1_result == 2)	
	
Test 1, part 2: $(test1_part2_result == 1)
	"
end

# ╔═╡ 4a629040-347a-11eb-2aae-6f37a4c89168
input_day2 = parse_day2(readlines("data/day02.txt"))

# ╔═╡ 5825aa50-347a-11eb-37ca-811e1b59d37a
md"**Result for part 1**: $(nb_of_valid_passwords_part1(input_day2))"

# ╔═╡ de3c2f00-347b-11eb-0aec-8b776a855f6a
md"**Result for part 2**: $(nb_of_valid_passwords_part2(input_day2))"

# ╔═╡ 14e39f60-3536-11eb-0c2a-5945a1ccb638
md"## Day 3"

# ╔═╡ 1b7ec110-3536-11eb-04c4-af7b43e6c68e
function parse_day3(lines)	
	map(==("#"), hcat(split.(lines, "")...))'
end

# ╔═╡ a6abdfc0-3536-11eb-3003-c13c39952d78
function nb_trees_encountered(area :: AbstractArray{Bool, 2}, moves = [(1, 3)])
	m, n = size(area)
	map(moves) do (di, dj)					
		foldl(1:di:m, init = (1, 0)) do (j, sum), i
			mod1(j + dj, n), sum + area[i, j]
		end[2]
	end
end

# ╔═╡ 1814fa70-353c-11eb-20de-51f779e98bdb
nb_trees_encountered_part2(area) = nb_trees_encountered(area, [(1, 1), (1, 3), (1, 5), (1, 7), (2, 1)])

# ╔═╡ da0fb260-3536-11eb-2c09-8f1b322090ab
let
	test_input = 
	 """..##.......
		#...#...#..
		.#....#..#.
		..#.#...#.#
		.#...##..#.
		..#.##.....
		.#.#.#....#
		.#........#
		#.##...#...
		#...##....#
		.#..#...#.#"""
	trees = parse_day3(split(test_input, '\n'))
	n_part1 = nb_trees_encountered(trees)	
	n_part2 = nb_trees_encountered_part2(trees)
	
	md"
Test 1, part 1: $(n_part1 == [7])

Test 1, part 2: $(prod(n_part2) == 336)
	"
end

# ╔═╡ 6b1aac80-3553-11eb-0816-6b74dcff2b86
input_day3 = parse_day3(readlines("data/day03.txt"))

# ╔═╡ ab7f3260-3539-11eb-3f97-fde10d5d852b
md"
**Result for part 1**: $(nb_trees_encountered(input_day3))

**Result for part 2**: $(nb_trees_encountered_part2(input_day3) |> prod)
"

# ╔═╡ Cell order:
# ╟─661be9a0-353b-11eb-3598-a5b5245368cb
# ╟─f0dd4400-3313-11eb-3295-af913c2212fb
# ╟─0b7b8920-3314-11eb-2cfb-7d20c0967e67
# ╠═877b32e0-3315-11eb-0e96-650b19da693e
# ╠═4adcf8d0-33a8-11eb-0220-696f06894ef3
# ╠═1e8e7230-33ae-11eb-0a77-035e6a4b9ba8
# ╟─7a037310-33ac-11eb-34fb-9bf552883937
# ╟─c7dcdae0-33b1-11eb-2cab-fbc06c8ef76b
# ╟─5d9712b0-3472-11eb-1423-719331dfe52f
# ╠═b9144990-3473-11eb-0ba9-59f3fe6ddbc0
# ╠═bbda1c1e-347a-11eb-0e7a-756906c4c9f4
# ╠═10f5ffa0-3474-11eb-2a36-d5c6f78f18c6
# ╠═6695038e-3472-11eb-1846-3b1c041be59d
# ╟─a0cfb670-3474-11eb-1a05-c12914658a0a
# ╟─4a629040-347a-11eb-2aae-6f37a4c89168
# ╟─5825aa50-347a-11eb-37ca-811e1b59d37a
# ╟─de3c2f00-347b-11eb-0aec-8b776a855f6a
# ╟─14e39f60-3536-11eb-0c2a-5945a1ccb638
# ╠═1b7ec110-3536-11eb-04c4-af7b43e6c68e
# ╠═a6abdfc0-3536-11eb-3003-c13c39952d78
# ╠═1814fa70-353c-11eb-20de-51f779e98bdb
# ╟─da0fb260-3536-11eb-2c09-8f1b322090ab
# ╟─6b1aac80-3553-11eb-0816-6b74dcff2b86
# ╟─ab7f3260-3539-11eb-3f97-fde10d5d852b
