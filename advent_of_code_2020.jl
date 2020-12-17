### A Pluto.jl notebook ###
# v0.12.17

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
md"
# 🦌 Advent Of Code 2020

The goals are:
* Learn *Julia*
* Write readable code (avoid golfing)
* Write efficient code if possible

See [Advent Of Code 2020](https://adventofcode.com/2020) for more information.
"

# ╔═╡ 0b7b8920-3314-11eb-2cfb-7d20c0967e67
md"## Day 1"

# ╔═╡ 877b32e0-3315-11eb-0e96-650b19da693e
input_day1 = parse.(Int64, readlines("data/day01.txt")) |> sort

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
md"
**Result for part 1:** $(day1_part1(input_day1))

**Result for part 2:** $(day1_part2(input_day1))"

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
parse_day3(lines) = map(==("#"), hcat(split.(lines, "")...))'

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

# ╔═╡ e43e2c90-35fd-11eb-1bf4-179363184fad
md"## Day 4"

# ╔═╡ eba88520-35fd-11eb-1810-819e3fb57682
function parse_day4(lines)
	passports = [Dict{String, String}()]
	for line ∈ lines
		if line == ""
			push!(passports, Dict())
		else
			for value in split(line, ' ')
				key_value = split(value, ':')
				last(passports)[key_value[1]] = key_value[2]
			end
		end
	end
	passports
end

# ╔═╡ 419cea1e-35fe-11eb-350c-19bf6016e01c
function count_nb_valid_passport(passports :: AbstractArray{Dict{String,String}}, check_fields_integrity = false)
	required_fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
	function check_field(field, value)		
		try
			field == "byr" && 1920 ≤ parse(Int, value) ≤ 2020 ||
			field == "iyr" && 2010 ≤ parse(Int, value) ≤ 2020 ||
			field == "eyr" && 2020 ≤ parse(Int, value) ≤ 2030 ||
			field == "hgt" &&
				((inches = match(r"(\d+)in", value)) ≠ nothing && 59 ≤ parse(Int, inches.captures[1]) ≤ 76 ||
				 (cm = match(r"(\d+)cm", value)) ≠ nothing && 150 ≤ parse(Int, cm.captures[1]) ≤ 193) ||
			field == "hcl" && occursin(r"^#[0-9a-f]{6}$", value) ||
			field == "ecl" && value ∈ ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"] ||
			field == "pid" && occursin(r"^[0-9]{9}$", value)
		catch
			false
		end
	end
	
	count(passports) do p
		all(required_fields) do f
			haskey(p, f) && (!check_fields_integrity || check_field(f, p[f]))
		end
	end
end

# ╔═╡ b8d2afc0-35ff-11eb-2fb1-7dba5d323768
let
	test1_part1 = "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in"
	
	result_test1_part1 = count_nb_valid_passport(parse_day4(split(test1_part1, '\n')))
	
	test1_part2 = "eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007"
	result_test1_part2 = count_nb_valid_passport(parse_day4(split(test1_part2, '\n')), true)
	
	test2_part2 = "pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022"
	result_test2_part2 = count_nb_valid_passport(parse_day4(split(test2_part2, '\n')), true)
		
	md"
Test 1, part 1: $(result_test1_part1 == 2)

Test 1, part 2: $(result_test1_part2 == 0)
	
Test 2, part 2: $(result_test2_part2 == 3)
	"
end

# ╔═╡ 6c01cf90-3600-11eb-0762-ad046d0d0775
input_day4 = parse_day4(readlines("data/day04.txt"))

# ╔═╡ 953ee8c2-3600-11eb-1684-79ff44185b5f
md"
**Result for part 1**: $(count_nb_valid_passport(input_day4))

**Result for part 2**: $(count_nb_valid_passport(input_day4, true))
"

# ╔═╡ 11d48ec0-3864-11eb-2dcf-3302fbb74b2d
md"## Day 5"

# ╔═╡ 18269980-3864-11eb-19d6-71f75b104ae5
function parse_day5(lines)
	map(lines) do line		
		row = parse(Int, join(replace(split(line[1:7], ""), "F" => "0", "B" => "1")); base = 2)
		col = parse(Int, join(replace(split(line[8:10], ""), "L" => "0", "R" => "1")); base = 2)
		row * 8 + col
	end
end

# ╔═╡ 9d237b60-3866-11eb-2dd8-c19a6cbded5b
let
	test = [ "FBFBBFFRLR" ]
	result = parse_day5(test)
	md"
Test 1, part 1: $(result[1] == 357)
	"
end

# ╔═╡ e881a6d0-3867-11eb-3261-0d86b4370065
function find_missing_id(ids)
	sorted_ids = sort(ids)
	for i ∈ 1:length(sorted_ids)-1
		if sorted_ids[i] + 1 ≠ sorted_ids[i + 1]
			return sorted_ids[i] + 1
		end
	end
end

# ╔═╡ cb986040-3867-11eb-0d78-594ac9d9a547
input_day5 = parse_day5(readlines("data/day05.txt"))

# ╔═╡ bdc1be30-3867-11eb-1939-1f0a42a4ac92
md"
**Result for part 1**: $(input_day5 |> maximum)

**Result for part 2**: $(find_missing_id(input_day5))
"

# ╔═╡ dc7eabf0-386a-11eb-22e7-578a73e3cd8f
md"## Day 6"

# ╔═╡ e1658df0-386a-11eb-39d9-218b9b2d494f
function parse_day6(lines) :: Array{Array{Set{Char}}}
	groups = [[]]
	for line ∈ lines
		if line == ""
			push!(groups, [])
		else
			push!(last(groups), Set(line))
		end
	end
	groups
end

# ╔═╡ cb221aa0-386e-11eb-22de-9d7379db14e2
function sum_of_group_lengths(groups, f)
	map(groups) do group
		length(reduce(f, group))
	end |> sum	
end

# ╔═╡ e9696760-386a-11eb-1aa3-ad421dc1fe83
let
	input = """
	abc
	
	a
	b
	c

	ab
	ac

	a
	a
	a
	a

	b"""
	
	result_part1 = sum_of_group_lengths(parse_day6(split(input, '\n')), union)
	result_part2 = sum_of_group_lengths(parse_day6(split(input, '\n')), intersect)
	md"
Test 1, part 1: $(result_part1 == 11)
	
Test 1, part 2: $(result_part2 == 6)
	"
end

# ╔═╡ 0a51a420-386f-11eb-025d-b9d1e1b79fd8
begin 
	file = "data/day06.txt"
	input_day6 = parse_day6(readlines(file))
	md"Number of groups read from *$file*: $(length(input_day6))"
end

# ╔═╡ dd1a2f00-3872-11eb-2ae9-ad73995fc382
md"
**Result for part 1**: $(sum_of_group_lengths(input_day6, union))

**Result for part 2**: $(sum_of_group_lengths(input_day6, intersect))
"

# ╔═╡ 22426ef0-388f-11eb-38a3-232fb088ef4f
md"## Day 7"

# ╔═╡ 94a84a10-389d-11eb-12a7-630db0e13276
struct Bags
	matrix :: Array{Int, 2}
	names :: Dict{String, Int}
end

# ╔═╡ 295cabb0-388f-11eb-2227-d73ae2c1e781
function parse_day7(lines)
	l = length(lines)
	m = zeros(Int, l, l)	
	name_indices = Dict{String, Int}()
	
	get_bag_index(name) = get!(name_indices, name, length(name_indices) + 1)
		
	for i ∈ 1:l
		line = lines[i]
		bag = match(r"^\w+ \w+", line).match		
		bag_index = get_bag_index(bag)
		for inner_bag ∈ eachmatch(r"(\d+) (\w+ \w+) bag", line)
			n = parse(Int, inner_bag[1])
			m[bag_index, get_bag_index(inner_bag[2])] = n
		end
	end
	
	Bags(m, name_indices)
end

# ╔═╡ 3ae9b650-38a0-11eb-1840-21cc6c2841b6
function bags_that_contain(name, bags)
	visited = falses(length(bags.names))
	to_visit = [bags.names[name]]	
	while !isempty(to_visit)
		current = pop!(to_visit)		
		
		visited[current] = true
		containing = findall(≠(0), bags.matrix[:, current] .* .!visited)
		 
		append!(to_visit, containing)
	end	
	findall(visited)
end

# ╔═╡ c26e4ed0-39f2-11eb-1338-57a3ce8069e0
function nb_bags_contained(name, bags)	
	function nb_bags_contained(bag_index)
		content = bags.matrix[bag_index, :]
		indexes = findall(≠(0), content)
		
		1 + (isempty(indexes) ? 0 : sum(nb_bags_contained.(indexes) .* filter(≠(0), content)))
	end
	
	nb_bags_contained(bags.names[name]) - 1
end

# ╔═╡ 30488570-388f-11eb-2ede-b10bdd1a06e8
let
	input₁ = "light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags."
	input₂ = "shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags."
	
	bags₁ = parse_day7(split(input₁, '\n'))
	bags₂ = parse_day7(split(input₂, '\n'))
	
	result_part1 = length(bags_that_contain("shiny gold", bags₁)) - 1
	result1_part2 = nb_bags_contained("shiny gold", bags₁) 	
	result2_part2 = nb_bags_contained("shiny gold", bags₂)
	
	md"
Test 1, part 1: $(result_part1 == 4)
	
Test 1, part 2: $(result1_part2 == 32)
	
Test 2, part 2: $(result2_part2 == 126)
	"
end

# ╔═╡ 20351e70-396e-11eb-25da-87d7ef27f902
input_day7 = parse_day7(readlines("data/day07.txt"))	

# ╔═╡ e825e690-39f9-11eb-21bc-099cc7a9e389
md"
**Result for part 1**: $(length(bags_that_contain(\"shiny gold\", input_day7)) - 1)

**Result for part 2**: $(nb_bags_contained(\"shiny gold\", input_day7))
"

# ╔═╡ c35b8110-3a0a-11eb-11e8-73b1b2080079
md"## Day 8"

# ╔═╡ 7c64c710-3a0c-11eb-17bb-1db527c932a3
struct Instruction
	operator :: Symbol
	argument :: Int
end

# ╔═╡ c8548b80-3a0a-11eb-067d-9dc6716dc325
function parse_day8(lines)
	map(lines) do line
		splitted = split(line, ' ')
		Instruction(Symbol(splitted[1]), parse(Int, splitted[2]))
	end
end

# ╔═╡ 9d1a8980-3a0d-11eb-380e-8fcaf30c849c
# The returned boolean is true if the execution has finished correctly or false if there is a infinite loop.
# The returned integer is the accumulator when the inifinite loop is detected or when the execution has finished correctly.
function execute(instructions) :: Tuple{Bool, Int}
	pos = 1
	accumulator = 0
	n = length(instructions)
	visited_positions = falses(n)
	
	while pos ≤ n && !visited_positions[pos]
		visited_positions[pos] = true
		ins = instructions[pos]
		if ins.operator == :acc
			accumulator += ins.argument
			pos += 1			
		elseif ins.operator == :jmp
			pos += ins.argument
		else # :nop.
			pos += 1
		end
	end
	pos > n, accumulator
end

# ╔═╡ 0f1d5380-3a10-11eb-2a71-1f0fddf65b70
function fix_to_not_loop(instructions)
	copy = deepcopy(instructions) # To avoid modifying the input.
		
	function switch(pos)
		if copy[pos].operator == :jmp
			copy[pos] = Instruction(:nop, copy[pos].argument)
			true
		elseif copy[pos].operator == :nop
			copy[pos] = Instruction(:jmp, copy[pos].argument)
			true
		else
			false
		end
	end
	
	for i ∈ 1:length(copy)
		if switch(i)
			finished, accumulator = execute(copy)
			if finished
				return accumulator
			end
			switch(i)
		end
	end
end

# ╔═╡ d6afedee-3a0a-11eb-31d7-3f16633dbf5d
let
	input = "nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6"
	code = parse_day8(split(input, '\n'))
	test1_part1 = execute(code)	
	test1_part2 = fix_to_not_loop(code)
	
	md"
Test 1, part 1: $(test1_part1 == (false, 5))
	
Test 1, part 2: $(test1_part2 == 8)
	"
end

# ╔═╡ aa322be0-3a0e-11eb-27ec-d13acf9084aa
input_day8 = parse_day8(readlines("data/day08.txt"))	

# ╔═╡ d867dd80-3a12-11eb-1ae7-3119a294b25a
md"
**Result for part 1**: $(execute(input_day8))

**Result for part 2**: $(fix_to_not_loop(input_day8))
"

# ╔═╡ ed5f09a0-3a2d-11eb-3592-6bec15fbc19b
md"## Day [9]"

# ╔═╡ f5750b80-3a2d-11eb-2edc-a767123b4bee
parse_day9(lines) = parse.(Int64, lines)

# ╔═╡ 2c12b6f0-3a2f-11eb-2aca-b54f0aeb9807
function first_number_without_valid_pair(numbers, preamble_size)	
	for i ∈ preamble_size+1:length(numbers)
		previous = numbers[i-preamble_size:i-1]
		n = numbers[i]
		if n ∉ [a + b for a ∈ previous for b ∈ previous if a ≠ b]
			return n
		end
	end
end

# ╔═╡ 0218f5c0-3a35-11eb-3833-a7472bcbc11b
function find_encryption_weakness(numbers, target)
	l = length(numbers)
	for i ∈ 1:l
		for j ∈ i+1:l			
			ξ = numbers[i:j]
			s = sum(ξ)
			if s == target 
				return extrema(ξ) |> sum
			elseif s > target
				break
			end
		end
	end
end

# ╔═╡ 2c96db10-3a2f-11eb-266d-3db1dfe51f8c
let
	input = "35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576"
	numbers = parse_day9(split(input, '\n'))	
	
	result_part1 = first_number_without_valid_pair(numbers, 5)
	result_part2 = find_encryption_weakness(numbers, result_part1)
	
	md"
Test 1, part 1: $(result_part1 == 127)
	
Test 1, part 2: $(result_part2 == 62)
	"
end

# ╔═╡ 299e6950-3a34-11eb-1080-6d172718b1ba
input_day9 = parse_day9(readlines("data/day09.txt"))

# ╔═╡ 484f9ea0-3a34-11eb-28a2-a95d5444ad50
let
	target = first_number_without_valid_pair(input_day9, 25)	
	md"
**Result for part 1**: $target

**Result for part 2**: $(find_encryption_weakness(input_day9, target))
"
end

# ╔═╡ 8dbc1ed0-3ae5-11eb-04fb-917b1bd334fe
md"## Day 10"

# ╔═╡ 949a6400-3ae5-11eb-24a8-ad11cff7ebf4
parse_day10(lines) = parse.(Int64, lines)

# ╔═╡ a8a0e2ce-3ae5-11eb-3e36-570fd0d07492
function joltage_differences(ratings)
	sorted = sort(ratings)
	diff(vcat(0, sorted, sorted[end] + 3))
end

# ╔═╡ 220a4ae2-3e14-11eb-0c7c-b122dc09f8c2
nb_of_3_time_number_of_1(nums) = count(==(3), nums) * count(==(1), nums)

# ╔═╡ b647ad20-3e18-11eb-36c7-b5cd7e0a0f1b
function nb_of_arrangements(diff)
	product = 1
	current = 0
	for e ∈ diff
		if e == 3
			if current > 1		
				product *= 2 ^ (current - 1)
			end
			current = 0
		elseif e == 1
			current += 1
		end
	end
	product	
end	

# ╔═╡ af716c60-3ae5-11eb-3ffb-43ba2903fda1
let
	input₁ = parse_day10(split("16 10 15 5 1 11 7 19 6 12 4", ' '))
	input₂ = parse_day10(split("28 33 18 42 31 14 46 20 48 47 24 23 49 45 19 38 39 11 1 32 25 35 8 17 7 9 4 2 34 10 3", ' '))
	
	@show nb_of_arrangements(joltage_differences(input₂))
	
	result_test_1_part1 = nb_of_3_time_number_of_1(joltage_differences(input₁))
	result_test_2_part1 = nb_of_3_time_number_of_1(joltage_differences(input₂))
	
	md"
Test 1, part 1: $(result_test_1_part1 == 35)
	
Test 2, part 1: $(result_test_2_part1 == 220)
	"
end

# ╔═╡ 8e796300-3e14-11eb-1c5e-49034b090e74
input_day10 = parse_day9(readlines("data/day10.txt"))

# ╔═╡ 992eeef0-3e14-11eb-0f06-af6990f63c9b
nb_of_3_time_number_of_1(joltage_differences(input_day10))

# ╔═╡ 9542b1e0-3e1a-11eb-2f2d-d78b9a39014c


# ╔═╡ Cell order:
# ╟─661be9a0-353b-11eb-3598-a5b5245368cb
# ╟─f0dd4400-3313-11eb-3295-af913c2212fb
# ╟─0b7b8920-3314-11eb-2cfb-7d20c0967e67
# ╟─877b32e0-3315-11eb-0e96-650b19da693e
# ╠═4adcf8d0-33a8-11eb-0220-696f06894ef3
# ╠═1e8e7230-33ae-11eb-0a77-035e6a4b9ba8
# ╟─7a037310-33ac-11eb-34fb-9bf552883937
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
# ╟─e43e2c90-35fd-11eb-1bf4-179363184fad
# ╠═eba88520-35fd-11eb-1810-819e3fb57682
# ╠═419cea1e-35fe-11eb-350c-19bf6016e01c
# ╟─b8d2afc0-35ff-11eb-2fb1-7dba5d323768
# ╟─6c01cf90-3600-11eb-0762-ad046d0d0775
# ╟─953ee8c2-3600-11eb-1684-79ff44185b5f
# ╟─11d48ec0-3864-11eb-2dcf-3302fbb74b2d
# ╠═18269980-3864-11eb-19d6-71f75b104ae5
# ╟─9d237b60-3866-11eb-2dd8-c19a6cbded5b
# ╠═e881a6d0-3867-11eb-3261-0d86b4370065
# ╟─cb986040-3867-11eb-0d78-594ac9d9a547
# ╟─bdc1be30-3867-11eb-1939-1f0a42a4ac92
# ╟─dc7eabf0-386a-11eb-22e7-578a73e3cd8f
# ╠═e1658df0-386a-11eb-39d9-218b9b2d494f
# ╠═cb221aa0-386e-11eb-22de-9d7379db14e2
# ╟─e9696760-386a-11eb-1aa3-ad421dc1fe83
# ╟─0a51a420-386f-11eb-025d-b9d1e1b79fd8
# ╟─dd1a2f00-3872-11eb-2ae9-ad73995fc382
# ╟─22426ef0-388f-11eb-38a3-232fb088ef4f
# ╠═94a84a10-389d-11eb-12a7-630db0e13276
# ╠═295cabb0-388f-11eb-2227-d73ae2c1e781
# ╠═3ae9b650-38a0-11eb-1840-21cc6c2841b6
# ╠═c26e4ed0-39f2-11eb-1338-57a3ce8069e0
# ╟─30488570-388f-11eb-2ede-b10bdd1a06e8
# ╟─20351e70-396e-11eb-25da-87d7ef27f902
# ╟─e825e690-39f9-11eb-21bc-099cc7a9e389
# ╟─c35b8110-3a0a-11eb-11e8-73b1b2080079
# ╠═7c64c710-3a0c-11eb-17bb-1db527c932a3
# ╠═c8548b80-3a0a-11eb-067d-9dc6716dc325
# ╠═9d1a8980-3a0d-11eb-380e-8fcaf30c849c
# ╠═0f1d5380-3a10-11eb-2a71-1f0fddf65b70
# ╟─d6afedee-3a0a-11eb-31d7-3f16633dbf5d
# ╟─aa322be0-3a0e-11eb-27ec-d13acf9084aa
# ╟─d867dd80-3a12-11eb-1ae7-3119a294b25a
# ╟─ed5f09a0-3a2d-11eb-3592-6bec15fbc19b
# ╠═f5750b80-3a2d-11eb-2edc-a767123b4bee
# ╠═2c12b6f0-3a2f-11eb-2aca-b54f0aeb9807
# ╠═0218f5c0-3a35-11eb-3833-a7472bcbc11b
# ╟─2c96db10-3a2f-11eb-266d-3db1dfe51f8c
# ╟─299e6950-3a34-11eb-1080-6d172718b1ba
# ╟─484f9ea0-3a34-11eb-28a2-a95d5444ad50
# ╟─8dbc1ed0-3ae5-11eb-04fb-917b1bd334fe
# ╠═949a6400-3ae5-11eb-24a8-ad11cff7ebf4
# ╠═a8a0e2ce-3ae5-11eb-3e36-570fd0d07492
# ╠═220a4ae2-3e14-11eb-0c7c-b122dc09f8c2
# ╠═b647ad20-3e18-11eb-36c7-b5cd7e0a0f1b
# ╠═af716c60-3ae5-11eb-3ffb-43ba2903fda1
# ╟─8e796300-3e14-11eb-1c5e-49034b090e74
# ╠═992eeef0-3e14-11eb-0f06-af6990f63c9b
# ╠═9542b1e0-3e1a-11eb-2f2d-d78b9a39014c
