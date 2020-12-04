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
# ╟─e43e2c90-35fd-11eb-1bf4-179363184fad
# ╠═eba88520-35fd-11eb-1810-819e3fb57682
# ╠═419cea1e-35fe-11eb-350c-19bf6016e01c
# ╟─b8d2afc0-35ff-11eb-2fb1-7dba5d323768
# ╟─6c01cf90-3600-11eb-0762-ad046d0d0775
# ╟─953ee8c2-3600-11eb-1684-79ff44185b5f
