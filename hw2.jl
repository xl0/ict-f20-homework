### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ a4937996-f314-11ea-2ff9-615c888afaa8
begin

	# IDK why they insist on a local package environment, I dnon't want to re-download
	# the packages every time!
	# Pkg.add([
	# 		"Images",
	# 		"ImageMagick",
	# 		"Compose",
	# 		"ImageFiltering",
	# 		"TestImages",
	# 		"Statistics",
	# 		"PlutoUI",
	# 		"BenchmarkTools"
	# 		])

	using Images
	using TestImages
	using ImageFiltering
	using Statistics
	using PlutoUI
	using BenchmarkTools
end

# ╔═╡ 33e43c7c-f381-11ea-3abc-c942327456b1
# edit the code below to set your name and kerberos ID (i.e. email without @mit.edu)

student = (name = "Alexey Zaytsev", kerberos_id = "alex")

# you might need to wait until all other cells in this notebook have completed running. 
# scroll around the page to see what's up

# ╔═╡ 86e1ee96-f314-11ea-03f6-0f549b79e7c9
#begin
#	using Pkg
#	Pkg.activate(mktempdir())
#end

# ╔═╡ 0d144802-f319-11ea-0028-cd97a776a3d0
#img = load(download("https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Piet_Mondriaan%2C_1930_-_Mondrian_Composition_II_in_Red%2C_Blue%2C_and_Yellow.jpg/300px-Piet_Mondriaan%2C_1930_-_Mondrian_Composition_II_in_Red%2C_Blue%2C_and_Yellow.jpg"))
#img = load(download("https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/Hilma_af_Klint_-_Group_IX_SUW%2C_The_Swan_No._1_%2813947%29.jpg/477px-Hilma_af_Klint_-_Group_IX_SUW%2C_The_Swan_No._1_%2813947%29.jpg"))
img = load(download("https://i.imgur.com/4SRnmkj.png"))

# ╔═╡ b49a21a6-f381-11ea-1a98-7f144c55c9b7
html"""
<iframe width="100%" height="450px" src="https://www.youtube.com/embed/gTGJ80HayK0?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ 75539476-a8c1-4098-bff1-d9797fbba074
copy(img)

# ╔═╡ 77798078-48c2-4f9a-af92-a209190d3e15

# This is the way to get an uninitialized array of the same type and dimensions! Gives a window into unintialized memory!
similar(img)

# ╔═╡ e501ea28-f326-11ea-252a-53949fd9ef57
performance_experiment_default = @benchmark remove_in_each_row(img, 1:size(img, 1))

# ╔═╡ 67717d02-f327-11ea-0988-bfe661f57f77
performance_experiment_without_vcat = @benchmark remove_in_each_row_no_vcat(img, 1:size(img, 1))

# ╔═╡ 3335e07c-f328-11ea-0e6c-8d38c8c0ad5b
performance_experiment_views = @benchmark begin
	remove_in_each_row_views(img, 1:size(img, 1))
end

# ╔═╡ 4f0975d8-f329-11ea-3d10-59a503f8d6b2
(
	default = performance_experiment_default, 
	without_vcat = performance_experiment_without_vcat,
	views = performance_experiment_views,
)

# ╔═╡ 6c7e4b54-f318-11ea-2055-d9f9c0199341
begin
	brightness(c::RGB) = mean((c.r, c.g, c.b))
	brightness(c::RGBA) = mean((c.r, c.g, c.b))
end

# ╔═╡ 74059d04-f319-11ea-29b4-85f5f8f5c610
Gray.(brightness.(img))

# ╔═╡ d184e9cc-f318-11ea-1a1e-994ab1330c1a
convolve(img, k) = imfilter(img, reflect(k)) # uses ImageFiltering.jl package
# behaves the same way as the `convolve` function used in Lecture 2
# You were asked to implement this in homework 1.

# ╔═╡ cdfb3508-f319-11ea-1486-c5c58a0b9177
float_to_color(x) = RGB(max(0, -x), max(0, x), 0)

# ╔═╡ 6f37b34c-f31a-11ea-2909-4f2079bf66ec
begin
	energy(∇x, ∇y) = sqrt.(∇x.^2 .+ ∇y.^2)
	function energy(img)
		∇y = convolve(brightness.(img), Kernel.sobel()[1])
		∇x = convolve(brightness.(img), Kernel.sobel()[2])
		energy(∇x, ∇y)
	end
end

# ╔═╡ 9fa0cd3a-f3e1-11ea-2f7e-bd73b8e3f302
float_to_color.(energy(img).+0.1) # +0.1 to brighten it up just a but

# ╔═╡ f5a74dfc-f388-11ea-2577-b543d31576c6
html"""
<iframe width="100%" height="450px" src="https://www.youtube.com/embed/rpB6zQNsbQU?start=777&end=833" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
"""

# ╔═╡ 2f9cbea8-f3a1-11ea-20c6-01fd1464a592
random_seam(m, n, i) = reduce((a, b) -> [a..., clamp(last(a) + rand(-1:1), 1, n)], 1:m-1; init=[i])

# ╔═╡ b0698d60-72d7-4c74-aa81-97cd97b448fa
#greedy_seam(Gray.(rand(Float64, (8,10))), 1)

# ╔═╡ b479cb8b-616e-40e0-adab-a568d6f648dd
#greedy_test1 = (rand(Float64, (8, 8)))

# ╔═╡ 405894ee-497b-4ec0-9da6-a2082187c3b7
#greedy_seam(greedy_test1, 5)

# ╔═╡ f580527e-f397-11ea-055f-bb9ea8f12015
# try
# 	if length(Set(greedy_seam(greedy_test, 5))) == 1
# 		md"Right now you are seeing the placeholder function. (You haven't done the exercise yet!) This is a straight line from the starting pixel."
# 	end
# catch end

# ╔═╡ 9ba83676-15ae-464d-8943-b83690d5ddbf


# ╔═╡ 7ddee6fc-f394-11ea-31fc-5bd665a65bef
greedy_test = Gray.(rand(Float64, (8,10)));

# ╔═╡ 2a98f268-f3b6-11ea-1eea-81c28256a19e
function fib(n)
    # base case (basis)
	if n == 0 || n == 1      # `||` means "or"
		return 1
	end

    # recursion (induction)
	return fib(n-1) + fib(n-2)
end

# ╔═╡ cbf29020-f3ba-11ea-2cb0-b92836f3d04b
begin
	struct AccessTrackerArray{T,N} <: AbstractArray{T, N}
		data::Array{T,N}
		accesses::Ref{Int}
	end
	track_access(x) = AccessTrackerArray(x, Ref(0))
	
	Base.IndexStyle(::Type{AccessTrackerArray}) = IndexLinear()
	
	Base.size(x::AccessTrackerArray) = size(x.data)
	Base.getindex(x::AccessTrackerArray, i::Int...) = (x.accesses[] += 1; x.data[i...])
	Base.setindex!(x::AccessTrackerArray, v, i...) = (x.accesses[] += 1; x.data[i...] = v;)
end

# ╔═╡ e6b6760a-f37f-11ea-3ae1-65443ef5a81a
md"_homework 2, version 2.1_"

# ╔═╡ ec66314e-f37f-11ea-0af4-31da0584e881
md"""

Submission by: **_$(student.name)_** ($(student.kerberos_id)@mit.edu)
"""

# ╔═╡ 85cfbd10-f384-11ea-31dc-b5693630a4c5
md"""

# **Homework 2**: _Dynamic programming_
`18.S191`, fall 2020

This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.

_For MIT students:_ there will also be some additional (secret) test cases that will be run as part of the grading process, and we will look at your notebook and write comments.

Feel free to ask questions!
"""

# ╔═╡ 938185ec-f384-11ea-21dc-b56b7469f798
md"_Let's create a package environment:_"

# ╔═╡ cc9fcdae-f314-11ea-1b9a-1f68b792f005
md"""
# Arrays: Slices and views

In the lecture (included below) we learned about what array views are. In this exercise we will add to that understanding and look at an important use of `view`s: to reduce the amount of memory allocations when reading sub-sequences within an array.

We will use the `BenchmarkTools` package to emperically understand the effects of using views.
"""

# ╔═╡ b49e8cc8-f381-11ea-1056-91668ac6ae4e
md"""
## Shrinking an array

Below is a function called `remove_in_each_row(img, pixels)`. It takes a matrix `img` and a vector of integers, `pixels`, and shrinks the image by 1 pixel in width by removing the element `img[i, pixels[i]]` in every row. This function is one of the building blocks of the Image Seam algorithm we saw in the lecture.

Read it and convince yourself that it is correct.
"""

# ╔═╡ e799be82-f317-11ea-3ae4-6d13ece3fe10
function remove_in_each_row(img, column_numbers)
	@assert size(img, 1) == length(column_numbers) # same as the number of rows
	m, n = size(img)
	local img′ = similar(img, m, n-1) # create a similar image with one less column

	# The prime (′) in the variable name is written as \prime<TAB>
    # You cannot use apostrophe for this! (Apostrophe means the transpose of a matrix)

	for (i, j) in enumerate(column_numbers)
		img′[i, :] = vcat(img[i, 1:j-1], img[i, j+1:end])
	end
	return img′
end

# ╔═╡ c075a8e6-f382-11ea-2263-cd9507324f4f
md"Let's use it to remove the pixels on the diagonal. These are the image dimensions before and after doing so:"

# ╔═╡ 9cced1a8-f326-11ea-0759-0b2f22e5a1db
(before=size(img), after=size(remove_in_each_row(img, 1:size(img, 1))))

# ╔═╡ c5580124-49d9-4991-b42e-2722b7abd29a
[ remove_in_each_row(img, 1:size(img, 1)) img]

# ╔═╡ 1d893998-f366-11ea-0828-512de0c44915
md"""
## **Exercise 1** - _Making it efficient_

We can use the `@benchmark` macro from the [BenchmarkTools.jl](https://github.com/JuliaCI/BenchmarkTools.jl) package to benchmark fragments of Julia code. 

`@benchmark` takes an expression and runs it a number of times to obtain statistics about the run time and memory allocation. We generally take the minimum time as the most stable measurement of performance ([for reasons discussed in the paper on BenchmarkTools](http://www-math.mit.edu/~edelman/publications/robust_benchmarking.pdf))
"""

# ╔═╡ 59991872-f366-11ea-1036-afe313fb4ec1
md"""
First, as an example, let's benchmark the `remove_in_each_row` function we defined above by passing in our image and a some indices to remove.
"""

# ╔═╡ f7915918-f366-11ea-2c46-2f4671ae8a22
md"""
#### Exercise 1.1

`vcat(x, y)` is used in julia to concatenate two arrays vertically. This actually creates a new array of size `length(x) + length(y)` and copies `x` and `y` into it.  We use it in `remove_in_each_row` to create rows which have one pixel less.

While using `vcat` might make it easy to write the first version of our function, it's strictly not necessary.

👉 In `remove_in_each_row_no_vcat` below, figure out a way to avoid the use of `vcat` and modify the function to avoid it.
"""

# ╔═╡ 37d4ea5c-f327-11ea-2cc5-e3774c232c2b
function remove_in_each_row_no_vcat(img, column_numbers)
	@assert size(img, 1) == length(column_numbers) # same as the number of rows
	m, n = size(img)
	local img2 = similar(img, m, n-1) # create a similar image with one less column

	for (i, j) in enumerate(column_numbers)
		# EDIT THE FOLLOWING LINE and split it into two lines
		# to avoid using `vcat`.
		img2[i, 1:j-1] = img[i, 1:j-1]
		img2[i, j:end] = img[i, j+1:end]
			#.= vcat(img[i, 1:j-1], img[i, j+1:end])
	end
	img2
end

# ╔═╡ 9e149cd2-f367-11ea-28ef-b9533e8a77bb
md"""
If you did it correctly, you should see that this benchmark shows the function running faster! And "memory estimate" should also show a smaller number, and so should "allocs estimate" which is the number of allocations done per call.
"""

# ╔═╡ ba1619d4-f389-11ea-2b3f-fd9ba71cf7e3
md"""
#### Exercise 1.2

👉 How many estimated allocations did this optimization reduce, and how can you explain most of them?
"""

# ╔═╡ e49235a4-f367-11ea-3913-f54a4a6b2d6b
no_vcat_observation = md"""
About half, since we don't need to create an intermediate array using vcat, and then copy it into the elements of the output matrix.
"""

# ╔═╡ 837c43a4-f368-11ea-00a3-990a45cb0cbd
md"""

#### Exercise 1.3 - `view`-based optimization

👉 In the below `remove_in_each_row_views` function, implement the same optimization to remove `vcat` and use `@view` or `@views` to avoid creating copies or slices of the `img` array.

Pluto will automatically time your change with `@benchmark` below.
"""

# ╔═╡ 90a22cc6-f327-11ea-1484-7fda90283797
function remove_in_each_row_views(img, column_numbers)
	@assert size(img, 1) == length(column_numbers) # same as the number of rows
	m, n = size(img)
	local img2 = similar(img, m, n-1) # create a similar image with one less column

	for (i, j) in enumerate(column_numbers)
		# EDIT THE FOLLOWING LINE and split it into two lines
		# to avoid using `vcat`.

		img2[i, 1:j-1] .= @view img[i, 1:j-1]
		img2[i, j:end] .= @view img[i, j+1:end]
		#img′[i, :] .= vcat(img[i, 1:j-1], img[i, j+1:end])
	end
	img2
end

# ╔═╡ 40d6f562-f329-11ea-2ee4-d7806a16ede3
md"Final tally:"

# ╔═╡ dc63d32a-f387-11ea-37e2-6f3666a72e03
⧀(a, b) = minimum(a).allocs + size(img, 1) ÷ 2  < minimum(b).allocs;

# ╔═╡ 7eaa57d2-f368-11ea-1a70-c7c7e54bd0b1
md"""

#### Exercise 1.4

Nice! If you did your optimizations right, you should be able to get down the estimated allocations to a single digit number!

👉 How many allocations were avoided by adding the `@view` optimization over the `vcat` optimization? Why is this?
"""

# ╔═╡ fd819dac-f368-11ea-33bb-17148387546a
views_observation = md"""
Almost all of them. We don't need to allocate any new arrays, just the ouput matrix once, and we copy the elements from the views of the original data.
"""

# ╔═╡ 318a2256-f369-11ea-23a9-2f74c566549b
md"""
## _Brightness and Energy_
"""

# ╔═╡ 7a44ba52-f318-11ea-0406-4731c80c1007
md"""
First, we will define a `brightness` function for a pixel (a color) as the mean of the red, green and blue values.

You should use this function whenever the problem set asks you to deal with _brightness_ of a pixel.
"""

# ╔═╡ 0b9ead92-f318-11ea-3744-37150d649d43
md"""We provide you with a convolve function below.
"""

# ╔═╡ 5fccc7cc-f369-11ea-3b9e-2f0eca7f0f0e
md"""
finally we define the `energy` function which takes the Sobel gradients along x and y directions and computes the norm of the gradient for each pixel.
"""

# ╔═╡ 87afabf8-f317-11ea-3cb3-29dced8e265a
md"""
## **Exercise 2** - _Building up to dynamic programming_

In this exercise and the following ones, we will use the computational problem of Seam carving. We will think through all the "gut reaction" solutions, and then finally end up with the dynamic programming solution that we saw in the lecture.

In the process we will understand the performance and accuracy of each iteration of our solution.

### How to implement the solutions:

For every variation of the algorithm, your job is to write a function which takes a matrix of energies, and an index for a pixel on the first row, and computes a "seam" starting at that pixel.

The function should return a vector of as many integers as there are rows in the input matrix where each number points out a pixel to delete from the corresponding row. (it acts as the input to `remove_in_each_row`).
"""

# ╔═╡ 8ba9f5fc-f31b-11ea-00fe-79ecece09c25
md"""
#### Exercise 2.1 - _The greedy approach_

The first approach discussed in the lecture (included below) is the _greedy approach_: you start from your top pixel, and at each step you just look at the three neighbors below. The next pixel in the seam is the neighbor with the lowest energy.

"""

# ╔═╡ c3543ea4-f393-11ea-39c8-37747f113b96
md"""
👉 Implement the greedy approach.
"""

# ╔═╡ abf20aa0-f31b-11ea-2548-9bea4fab4c37
function greedy_seam(energies, starting_pixel::Int)
	m, n = size(energies)
	results = zeros(Int64, m)

	results[1] = starting_pixel
	for i in 2:m
		prev_j = results[i-1]
		min_index = max(1, prev_j-1)
		max_index = min(n, prev_j+1)
		results[i] = argmin(energies[i, min_index:max_index]) + min_index -1
	end
	return results
end

# ╔═╡ 5430d772-f397-11ea-2ed8-03ee06d02a22
md"Before we apply your function to our test image, let's try it out on a small matrix of energies (displayed here in grayscale), just like in the lecture snippet above (clicking on the video will take you to the right part of the video). Light pixels have high energy, dark pixels signify low energy."

# ╔═╡ 6f52c1a2-f395-11ea-0c8a-138a77f03803
md"Starting pixel: $(@bind greedy_starting_pixel Slider(1:size(greedy_test, 2); show_value=true))"

# ╔═╡ 9945ae78-f395-11ea-1d78-cf6ad19606c8
md"_Let's try it on the bigger image!_"

# ╔═╡ 87efe4c2-f38d-11ea-39cc-bdfa11298317
md"Compute shrunk image: $(@bind shrink_greedy CheckBox())"

# ╔═╡ 52452d26-f36c-11ea-01a6-313114b4445d
md"""
#### Exercise 2.2 - _Recursion_

A common pattern in algorithm design is the idea of solving a problem as the combination of solutions to subproblems.

The classic example, is a [Fibonacci number](https://en.wikipedia.org/wiki/Fibonacci_number) generator.

The recursive implementation of Fibonacci looks something like this
"""

# ╔═╡ 32e9a944-f3b6-11ea-0e82-1dff6c2eef8d
md"""
Notice that you can call a function from within itself which may call itself and so on until a base case is reached. Then the program will combine the result from the base case up to the final result.

In the case of the Fibonacci function, we added the solutions to the subproblems `fib(n-1)`, `fib(n-2)` to produce `fib(n)`.

An analogy can be drawn to the process of mathematical induction in mathematics. And as with mathematical induction there are parts to constructing such a recursive algorithm:

- Defining a base case
- Defining an recursion i.e. finding a solution to the problem as a combination of solutions to smaller problems.

"""

# ╔═╡ 9101d5a0-f371-11ea-1c04-f3f43b96ca4a
md"""
👉 Define a `least_energy` function which returns:
1. the lowest possible total energy for a seam starting at the pixel at $(i, j)$;
2. the column to jump to on the next move (in row $i + 1$),
which is one of $j-1$, $j$ or $j+1$, up to boundary conditions.

Return these two values in a tuple.
"""

# ╔═╡ 8ec27ef8-f320-11ea-2573-c97b7b908cb7
## returns lowest possible sum energy at pixel (i, j), and the column to jump to in row i+1.
function least_energy(energies, i, j)
	m, n = size(energies)
	
	if i == m
		println("typeof(i) = $(typeof(i)), typeof(j)=$(typeof(j))")

		return (energies[i, j], 1)
	end

	idx_min = max(1, j-1)
	idx_max = min(n, j+1)

	sub_energies = [least_energy(energies, i+1, idx)[1] for idx in idx_min:idx_max]

	# This one if relative to idx_min
	min_energy_rel_idx = argmin(sub_energies)
	# This one is absolure
	min_energy_idx = min_energy_rel_idx + idx_min - 1

	return (energies[i, j] + sub_energies[min_energy_rel_idx], min_energy_idx)
	

	# base case
	# if i == something
	#    return energies[...] # no need for recursive computation in the base case!
	# end
	#
	# induction
	# combine results from recursive calls to `least_energy`.
end

# ╔═╡ a7f3d9f8-f3bb-11ea-0c1a-55bbb8408f09
md"""
This is so elegant, correct, but inefficient! If you **check this checkbox** $(@bind compute_access CheckBox()), you will see the number of accesses made to the energies array it took to compute the least energy from the pixel (1,7):
"""

# ╔═╡ 18e0fd8a-f3bc-11ea-0713-fbf74d5fa41a
md"Whoa!"

# ╔═╡ 8bc930f0-f372-11ea-06cb-79ced2834720
md"""
#### Exercise 2.3 - _Exhaustive search with recursion_

Now use the `least_energy` function you defined above to define the `recursive_seam` function which takes the energies matrix and a starting pixel, and computes the seam with the lowest energy from that starting pixel.

This will give you the method used in the lecture to perform [exhaustive search of all possible paths](https://youtu.be/rpB6zQNsbQU?t=839).
"""

# ╔═╡ 85033040-f372-11ea-2c31-bb3147de3c0d
function recursive_seam(energies, starting_pixel)
	m, n = size(energies)
	outputs = zeros(Int, m)
	outputs[1] = starting_pixel
	for i in 2:m
		outputs[i] = least_energy(energies, i-1, outputs[i-1])[2]
	end
	# Replace the following line with your code.
	return outputs
end

# ╔═╡ 1d55333c-f393-11ea-229a-5b1e9cabea6a
md"Compute shrunk image: $(@bind shrink_recursive CheckBox())"

# ╔═╡ 36288a21-f065-4bc1-bb15-942a98b9a188


# ╔═╡ c572f6ce-f372-11ea-3c9a-e3a21384edca
md"""
#### Exercise 2.4

- State clearly why this algorithm does an exhaustive search of all possible paths.
- How does the number of possible seam grow as n increases for a `m×n` image? (Big O notation is fine, or an approximation is fine).
"""

# ╔═╡ 6d993a5c-f373-11ea-0dde-c94e3bbd1552
exhaustive_observation = md"""
From the first row, we descend and try every pixel that is either directly below or one to the side. We end up trying at least 1/2 of all pixels in a square image.

Then for each of those pixels, we have to try one below and 2 on the sides.

The complexity is less than $O(m\times n)^2$, assuming m ~ n, but I don't know a more scientific way to find it.
"""

# ╔═╡ ea417c2a-f373-11ea-3bb0-b1b5754f2fac
md"""
## **Exercise 3** - _Memoization_

**Memoization** is the name given to the technique of storing results to expensive function calls that will be accessed more than once.

As stated in the video, the function `least_energy` is called repeatedly with the same arguments. In fact, we call it on the order of $3^n$ times, when there are only really $m \times n$ unique ways to call it!

Lets implement memoization on this function with first a [dictionary](https://docs.julialang.org/en/v1/base/collections/#Dictionaries) for storage.
"""

# ╔═╡ 56a7f954-f374-11ea-0391-f79b75195f4d
md"""
#### Exercise 3.1 - _Dictionary as storage_

Let's make a memoized version of least_energy function which takes a dictionary and
first checks to see if the dictionary contains the key (i,j) if it does, returns the value stored in that place, if not, will compute it, and store it in the dictionary at key (i, j) and return the value it computed.


`memoized_least_energy(energies, starting_pixel, memory)`

This function must recursively call itself, and pass the same `memory` object it received as an argument.

You are expected to read and understand the [documentation on dictionaries](https://docs.julialang.org/en/v1/base/collections/#Dictionaries) to find out how to:

1. Create a dictionary
2. Check if a key is stored in the dictionary
3. Access contents of the dictionary by a key.
"""

# ╔═╡ b1d09bc8-f320-11ea-26bb-0101c9a204e2
## !! Hey, am I missing something here? The function is still too slow to compute the seams over the full-size image. I had to decimate the image by 2 and it still takes 2 minutes to compute here. !!

function memoized_least_energy(energies, i, j, memory)
	m, n = size(energies)
	
	if i == m
		memory[(i, j)] = energies[i, j]
		return (memory[(i, j)], 0)
	end

	idx_start = max(1, j-1)
	idx_end = min(n, j+1)
	sub_energies = [ haskey(memory, (i+1, idx)) ? memory[(i+1, idx)] :    memoized_least_energy(energies, i+1, idx, memory)[1] for idx in idx_start:idx_end]

	# This one if relative to idx_min
	min_energy_rel_idx = argmin(sub_energies)
	# This one is absolure
	min_energy_idx = min_energy_rel_idx + idx_start - 1
	
	memory[(i, j)] = energies[i, j] + sub_energies[min_energy_rel_idx]
	
	return (memory[(i, j)], min_energy_idx)
end

# ╔═╡ 3e8b0868-f3bd-11ea-0c15-011bbd6ac051
function recursive_memoized_seam(energies, starting_pixel)
	memory = Dict{Tuple{Int,Int}, Float64}() # location => least energy, next index
	# pass this every time you call memoized_least_energy.
	m, n = size(energies)
	outputs = zeros(Int, m)
	outputs[1] = starting_pixel
	for i in 2:m
		outputs[i] = memoized_least_energy(energies, i-1, outputs[i-1], memory)[2]
	end
	# Replace the following line with your code.
	return outputs
end

# ╔═╡ 4e3bcf88-f3c5-11ea-3ada-2ff9213647b7
md"Compute shrunk image: $(@bind shrink_dict CheckBox())"

# ╔═╡ cf39fa2a-f374-11ea-0680-55817de1b837
md"""
### Exercise 3.2 - _Matrix as storage_

The dictionary-based memoization we tried above works well in general as there is no restriction on what type of keys can be used.

But in our particular case, we can use a matrix as a storage, since a matrix is naturally keyed by two integers.

Write a variation of `matrix_memoized_least_energy` and `matrix_memoized_seam` which use a matrix as storage.
"""

# ╔═╡ c8724b5e-f3bd-11ea-0034-b92af21ca12d
# !! This one is about twice as fast as the Dict one, but it's still too slow for a full image !!

function matrix_memoized_least_energy(energies, i, j, memory)
	m, n = size(energies)
	
	if i == m
		memory[i, j] = energies[i, j]
		return (memory[i, j], 0) # The returned index does not matter for the
								 # last row. Return 0 to catch possible errors.
	end

	idx_start = max(1, j-1)
	idx_end = min(n, j+1)
		
	sub_energies = [ memory[i+1, idx] != 0 ? memory[i+1, idx] :    matrix_memoized_least_energy(energies, i+1, idx, memory)[1] for idx in idx_start:idx_end]

	# This one if relative to idx_min
	min_energy_rel_idx = argmin(sub_energies)
	# This one is absolure
	min_energy_idx = min_energy_rel_idx + idx_start - 1
	
	memory[i, j] = energies[i, j] + sub_energies[min_energy_rel_idx]
	
	return (memory[i, j], min_energy_idx)
end

# ╔═╡ be7d40e2-f320-11ea-1b56-dff2a0a16e8d
function matrix_memoized_seam(energies, starting_pixel)
	memory = zeros(size(energies)) # use this as storage -- intially it's all zeros
	m, n = size(energies)
	
	outputs = zeros(Int, m)
	outputs[1] = starting_pixel
	for i in 2:m
		outputs[i] = matrix_memoized_least_energy(energies, i-1, outputs[i-1], memory)[2]
	end
	# Replace the following line with your code.
	return outputs

	
	# Replace the following line with your code.
	# [starting_pixel for i=1:m]
end

# ╔═╡ 507f3870-f3c5-11ea-11f6-ada3bb087634
md"Compute shrunk image: $(@bind shrink_matrix CheckBox())"

# ╔═╡ 24792456-f37b-11ea-07b2-4f4c8caea633
md"""
## **Exercise 4** - _Dynamic programming without recursion_ 

Now it's easy to see that the above algorithm is equivalent to one that populates the memory matrix in a for loop.

#### Exercise 4.1

👉 Write a function which takes the energies and returns the least energy matrix which has the least possible seam energy for each pixel. This was shown in the lecture, but attempt to write it on your own.
"""

# ╔═╡ ff055726-f320-11ea-32f6-2bf38d7dd310
function least_energy_matrix(energies)
	m, n = size(energies)
	
	output = zeros(size(energies))
	output[m,:] = @view energies[m,:]

	#output = copy(energies)
	
	for i in reverse(1:m-1)
		output[i, 1] = energies[i, 1] + minimum(@view output[i+1, 1:2]) 
		output[i, 2:n-1] = [energies[i, j] + minimum(@view output[i+1, j-1:j+1]) for j in 2:n-1]
		output[i, n] = energies[i, n] + minimum(@view output[i+1, end-1:end])
	end

	return output
end

# ╔═╡ e287774f-b372-4a44-92ae-dd7ce60c245e


# ╔═╡ 36d6e5f3-1e7d-4de8-9295-e45955ed8c7f
#Pretty!
begin
	lem = least_energy_matrix(energy(img))
	Gray.(lem ./ maximum(lem) )
end


# ╔═╡ 92e19f22-f37b-11ea-25f7-e321337e375e
md"""
#### Exercise 4.2

👉 Write a function which, when given the matrix returned by `least_energy_matrix` and a starting pixel (on the first row), computes the least energy seam from that pixel.
"""

# ╔═╡ 795eb2c4-f37b-11ea-01e1-1dbac3c80c13

function seam_from_precomputed_least_energy(energies, starting_pixel::Int)
	#println("seam_from_precomputed_least_energy($starting_pixel)")

	# !! THis is stupid! We recalculate the least_energy_matrix each time we want to check a new pixel!

	# It took 209 seconds to compute the test case!
	# But changing this would require rewriting the test code, and I can't bo bothered really.

	least_energies = least_energy_matrix(energies)
		
	m, n = size(least_energies)

	outputs = zeros(Int, m)
	outputs[1] = starting_pixel
	for i in 2:m
		idx_start = max(1, outputs[i-1]-1)
		idx_end = min(outputs[i-1]+1, n)

		outputs[i] = idx_start + argmin(least_energies[i, idx_start:idx_end]) -1
	end

	return outputs
	# Replace the following line with your code.
	# [starting_pixel for i=1:m]
end

# ╔═╡ 9eff40fc-8679-4dc2-987b-21c818d53b16
seam_from_precomputed_least_energy(energy(img), 1)

# ╔═╡ 51df0c98-f3c5-11ea-25b8-af41dc182bac
md"Compute shrunk image: $(@bind shrink_bottomup CheckBox())"

# ╔═╡ 0fbe2af6-f381-11ea-2f41-23cd1cf930d9
if student.kerberos_id === "jazz"
	md"""
!!! danger "Oops!"
    **Before you submit**, remember to fill in your name and kerberos ID at the top of this notebook!
	"""
end

# ╔═╡ 6b4d6584-f3be-11ea-131d-e5bdefcc791b
md"## Function library

Just some helper functions used in the notebook."

# ╔═╡ ef88c388-f388-11ea-3828-ff4db4d1874e
function mark_path(img, path)
	img′ = copy(img)
	m = size(img, 2)
	for (i, j) in enumerate(path)
		# To make it easier to see, we'll color not just
		# the pixels of the seam, but also those adjacent to it
		for j′ in j-1:j+1
			img′[i, clamp(j′, 1, m)] = RGB(1,0,1)
		end
	end
	img′
end

# ╔═╡ 437ba6ce-f37d-11ea-1010-5f6a6e282f9b
function shrink_n(img, n, min_seam, imgs=[]; show_lightning=true)
	n==0 && return push!(imgs, img)

	e = energy(img)
	seam_energy(seam) = sum(e[i, seam[i]]  for i in 1:size(img, 1))
	_, min_j = findmin(map(j->seam_energy(min_seam(e, j)), 1:size(e, 2)))
	min_seam_vec = min_seam(e, min_j)
	img′ = remove_in_each_row(img, min_seam_vec)
	if show_lightning
		push!(imgs, mark_path(img, min_seam_vec))
	else
		push!(imgs, img′)
	end
	shrink_n(img′, n-1, min_seam, imgs)
end

# ╔═╡ f6571d86-f388-11ea-0390-05592acb9195
if shrink_greedy
	greedy_carved = shrink_n(img, 200, greedy_seam)
	md"Shrink by: $(@bind greedy_n Slider(1:200; show_value=true))"
end

# ╔═╡ f626b222-f388-11ea-0d94-1736759b5f52
if shrink_greedy
	greedy_carved[greedy_n]
end

# ╔═╡ 51e28596-f3c5-11ea-2237-2b72bbfaa001
if shrink_bottomup
	bottomup_carved = shrink_n(img, 200, seam_from_precomputed_least_energy)
	md"Shrink by: $(@bind bottomup_n Slider(1:200, show_value=true))"
end

# ╔═╡ 0a10acd8-f3c6-11ea-3e2f-7530a0af8c7f
if shrink_bottomup
	bottomup_carved[bottomup_n]
end

# ╔═╡ ef26374a-f388-11ea-0b4e-67314a9a9094
function pencil(X)
	f(x) = RGB(1-x,1-x,1-x)
	map(f, X ./ maximum(X))
end

# ╔═╡ 6bdbcf4c-f321-11ea-0288-fb16ff1ec526
function decimate(img, n)
	img[1:n:end, 1:n:end]
end

# ╔═╡ ddba07dc-f3b7-11ea-353e-0f67713727fc
# Do not make this image bigger, it will be infeasible to compute.
pika = decimate(load(download("https://art.pixilart.com/901d53bcda6b27b.png")),150)

# ╔═╡ 73b52fd6-f3b9-11ea-14ed-ebfcab1ce6aa
size(pika)

# ╔═╡ fa8e2772-f3b6-11ea-30f7-699717693164
if compute_access
	tracked = track_access(energy(pika))
	least_energy(tracked, 1,7)
	tracked.accesses[]
end

# ╔═╡ d88bc272-f392-11ea-0efd-15e0e2b2cd4e
if shrink_recursive
	recursive_carved = shrink_n(pika, 3, recursive_seam)
	md"Shrink by: $(@bind recursive_n Slider(1:3, show_value=true))"
end

# ╔═╡ e66ef06a-f392-11ea-30ab-7160e7723a17
if shrink_recursive
	recursive_carved[recursive_n]
end

# ╔═╡ 148950fa-ee16-4511-81da-0b071c481fca
recursive_memoized_seam(energy([pika pika pika pika ; pika pika pika pika ; pika pika pika pika ]), 7)

# ╔═╡ 5ed81be9-a490-40ff-9dfb-b86c97ebc110
img_smol = decimate(img, 2) # The original image still takes too long!!!!

# ╔═╡ 18f0091a-a0e8-4d80-86a4-4ac32a2a70e4
recursive_memoized_seam(energy(img_smol), 10)
# It's definitely a lot faster than the dummy recursive seam, the dummy one was not done after half a minute here!


# ╔═╡ 4e3ef866-f3c5-11ea-3fb0-27d1ca9a9a3f
if shrink_dict
	dict_carved = shrink_n(img_smol, 200, recursive_memoized_seam)
	md"Shrink by: $(@bind dict_n Slider(1:200, show_value=true))"
end

# ╔═╡ 6e73b1da-f3c5-11ea-145f-6383effe8a89
if shrink_dict
	dict_carved[dict_n]
end

# ╔═╡ 50829af6-f3c5-11ea-04a8-0535edd3b0aa
if shrink_matrix
	matrix_carved = shrink_n(img_smol, 200, matrix_memoized_seam)
	md"Shrink by: $(@bind matrix_n Slider(1:200, show_value=true))"
end

# ╔═╡ 9e56ecfa-f3c5-11ea-2e90-3b1839d12038
if shrink_matrix
	matrix_carved[matrix_n]
end

# ╔═╡ ffc17f40-f380-11ea-30ee-0fe8563c0eb1
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ 9f18efe2-f38e-11ea-0871-6d7760d0b2f6
hint(md"You can call the `least_energy` function recursively within itself to obtain the least energy of the adjacent cells and add the energy at the current cell to get the total energy.")

# ╔═╡ ffc40ab2-f380-11ea-2136-63542ff0f386
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ ffceaed6-f380-11ea-3c63-8132d270b83f
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ ffde44ae-f380-11ea-29fb-2dfcc9cda8b4
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ 980b1104-f394-11ea-0948-21002f26ee25
function visualize_seam_algorithm(algorithm, test_img, starting_pixel)
	seam = algorithm(test_img, starting_pixel)
	
	display_img = RGB.(test_img)
	for (i, j) in enumerate(seam)
		try
			display_img[i, j] = RGB(0.9, 0.3, 0.6)
		catch ex
			if ex isa BoundsError
				return keep_working("")
			end
			# the solution might give an illegal index
		end
	end
	display_img
end;

# ╔═╡ 2a7e49b8-f395-11ea-0058-013e51baa554
visualize_seam_algorithm(greedy_seam, greedy_test, greedy_starting_pixel)

# ╔═╡ ffe326e0-f380-11ea-3619-61dd0592d409
yays = [md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ fff5aedc-f380-11ea-2a08-99c230f8fa32
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ e3519118-f387-11ea-0c61-e1c2de1c24c1
if performance_experiment_without_vcat ⧀ performance_experiment_default
	correct()
else
	keep_working(md"We are still using (roughly) the same number of allocations as the default implementation.")
end

# ╔═╡ d4ea4222-f388-11ea-3c8d-db0d651f5282
if performance_experiment_views ⧀ performance_experiment_default
	if minimum(performance_experiment_views).allocs < 10
		correct()
	else
		keep_working(md"We are still using (roughly) the same number of allocations as the implementation without `vcat`.")
	end
else
	keep_working(md"We are still using (roughly) the same number of allocations as the default implementation.")
end

# ╔═╡ 00026442-f381-11ea-2b41-bde1fff66011
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 145c0f58-f384-11ea-2b71-09ae83f66da2
if !@isdefined(views_observation)
	not_defined(:views_observation)
end

# ╔═╡ d7a9c000-f383-11ea-1516-cf71102d8e94
if !@isdefined(views_observation)
	not_defined(:views_observation)
end

# ╔═╡ e0622780-f3b4-11ea-1f44-59fb9c5d2ebd
if !@isdefined(least_energy_matrix)
	not_defined(:least_energy_matrix)
end

# ╔═╡ 946b69a0-f3a2-11ea-2670-819a5dafe891
if !@isdefined(seam_from_precomputed_least_energy)
	not_defined(:seam_from_precomputed_least_energy)
end

# ╔═╡ fbf6b0fa-f3e0-11ea-2009-573a218e2460
function hbox(x, y, gap=16; sy=size(y), sx=size(x))
	w,h = (max(sx[1], sy[1]),
		   gap + sx[2] + sy[2])
	
	slate = fill(RGB(1,1,1), w,h)
	slate[1:size(x,1), 1:size(x,2)] .= RGB.(x)
	slate[1:size(y,1), size(x,2) + gap .+ (1:size(y,2))] .= RGB.(y)
	slate
end

# ╔═╡ f010933c-f318-11ea-22c5-4d2e64cd9629
begin
	hbox(
		float_to_color.(convolve(brightness.(img), Kernel.sobel()[1])),
		float_to_color.(convolve(brightness.(img), Kernel.sobel()[2])))
end

# ╔═╡ 256edf66-f3e1-11ea-206e-4f9b4f6d3a3d
vbox(x,y, gap=16) = hbox(x', y')'

# ╔═╡ 00115b6e-f381-11ea-0bc6-61ca119cb628
bigbreak = html"<br><br><br><br><br>";

# ╔═╡ c086bd1e-f384-11ea-3b26-2da9e24360ca
bigbreak

# ╔═╡ 8d558c4c-f328-11ea-0055-730ead5d5c34
bigbreak

# ╔═╡ f7eba2b6-f388-11ea-06ad-0b861c764d61
bigbreak

# ╔═╡ 4f48c8b8-f39d-11ea-25d2-1fab031a514f
bigbreak

# ╔═╡ 48089a00-f321-11ea-1479-e74ba71df067
bigbreak

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
ImageFiltering = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
Images = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
TestImages = "5e47fb64-e119-507b-a336-dd2b206d9990"

[compat]
BenchmarkTools = "~1.2.0"
ImageFiltering = "~0.6.21"
Images = "~0.24.1"
PlutoUI = "~0.7.18"
TestImages = "~1.6.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractFFTs]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "485ee0867925449198280d4af84bdb46a2a404d0"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.0.1"

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "0ec322186e078db08ea3e7da5b8b2885c099b393"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.0"

[[Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "84918055d15b3114ede17ac6a7182f68870c16f7"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.1"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "e527b258413e0c6d4f66ade574744c94edef81f8"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "3.1.40"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[AxisArrays]]
deps = ["Dates", "IntervalSets", "IterTools", "RangeArrays"]
git-tree-sha1 = "d127d5e4d86c7680b20c35d40b503c74b9a39b5e"
uuid = "39de3d68-74b9-583c-8d2d-e117c070f3a9"
version = "0.4.4"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "61adeb0823084487000600ef8b1c00cc2474cd47"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.2.0"

[[CEnum]]
git-tree-sha1 = "215a9aa4a1f23fbd05b92769fdd62559488d70e9"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.1"

[[CatIndices]]
deps = ["CustomUnitRanges", "OffsetArrays"]
git-tree-sha1 = "a0f80a09780eed9b1d106a1bf62041c2efc995bc"
uuid = "aafaddc9-749c-510e-ac4f-586e18779b91"
version = "0.2.2"

[[ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "f885e7e7c124f8c92650d61b9477b9ac2ee607dd"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.11.1"

[[ChangesOfVariables]]
deps = ["LinearAlgebra", "Test"]
git-tree-sha1 = "9a1d594397670492219635b35a3d830b04730d62"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.1"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "45efb332df2e86f2cb2e992239b6267d97c9e0b6"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.7"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "dce3e3fea680869eaa0b774b2e8343e9ff442313"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.40.0"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[ComputationalResources]]
git-tree-sha1 = "52cb3ec90e8a8bea0e62e275ba577ad0f74821f7"
uuid = "ed09eef8-17a6-5b46-8889-db040fac31e3"
version = "0.3.2"

[[CoordinateTransformations]]
deps = ["LinearAlgebra", "StaticArrays"]
git-tree-sha1 = "681ea870b918e7cff7111da58791d7f718067a19"
uuid = "150eb455-5306-5404-9cee-2592286d6298"
version = "0.6.2"

[[CustomUnitRanges]]
git-tree-sha1 = "1a3f97f907e6dd8983b744d2642651bb162a3f7a"
uuid = "dc8bdbbb-1ca9-579f-8c36-e416f6a65cce"
version = "1.0.2"

[[DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distances]]
deps = ["LinearAlgebra", "Statistics", "StatsAPI"]
git-tree-sha1 = "837c83e5574582e07662bbbba733964ff7c26b9d"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.6"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[EllipsisNotation]]
deps = ["ArrayInterface"]
git-tree-sha1 = "9aad812fb7c4c038da7cab5a069f502e6e3ae030"
uuid = "da5c29d0-fa7d-589e-88eb-ea29b0a81949"
version = "1.1.1"

[[FFTViews]]
deps = ["CustomUnitRanges", "FFTW"]
git-tree-sha1 = "cbdf14d1e8c7c8aacbe8b19862e0179fd08321c2"
uuid = "4f61f5a4-77b1-5117-aa51-3ab5ef4ef0cd"
version = "0.3.2"

[[FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "463cb335fa22c4ebacfd1faba5fde14edb80d96c"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.4.5"

[[FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "2db648b6712831ecb333eae76dbfd1c156ca13bb"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.11.2"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "1c5a84319923bea76fa145d49e93aa4394c73fc2"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.1"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[IdentityRanges]]
deps = ["OffsetArrays"]
git-tree-sha1 = "be8fcd695c4da16a1d6d0cd213cb88090a150e3b"
uuid = "bbac6d45-d8f3-5730-bfe4-7a449cd117ca"
version = "0.3.1"

[[IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[ImageAxes]]
deps = ["AxisArrays", "ImageCore", "Reexport", "SimpleTraits"]
git-tree-sha1 = "794ad1d922c432082bc1aaa9fa8ffbd1fe74e621"
uuid = "2803e5a7-5153-5ecf-9a86-9b4c37f5f5ac"
version = "0.6.9"

[[ImageContrastAdjustment]]
deps = ["ColorVectorSpace", "ImageCore", "ImageTransformations", "Parameters"]
git-tree-sha1 = "2e6084db6cccab11fe0bc3e4130bd3d117092ed9"
uuid = "f332f351-ec65-5f6a-b3d1-319c6670881a"
version = "0.3.7"

[[ImageCore]]
deps = ["AbstractFFTs", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "db645f20b59f060d8cfae696bc9538d13fd86416"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.8.22"

[[ImageDistances]]
deps = ["ColorVectorSpace", "Distances", "ImageCore", "ImageMorphology", "LinearAlgebra", "Statistics"]
git-tree-sha1 = "6378c34a3c3a216235210d19b9f495ecfff2f85f"
uuid = "51556ac3-7006-55f5-8cb3-34580c88182d"
version = "0.2.13"

[[ImageFiltering]]
deps = ["CatIndices", "ColorVectorSpace", "ComputationalResources", "DataStructures", "FFTViews", "FFTW", "ImageCore", "LinearAlgebra", "OffsetArrays", "Requires", "SparseArrays", "StaticArrays", "Statistics", "TiledIteration"]
git-tree-sha1 = "bf96839133212d3eff4a1c3a80c57abc7cfbf0ce"
uuid = "6a3955dd-da59-5b1f-98d4-e7296123deb5"
version = "0.6.21"

[[ImageIO]]
deps = ["FileIO", "Netpbm", "OpenEXR", "PNGFiles", "TiffImages", "UUIDs"]
git-tree-sha1 = "a2951c93684551467265e0e32b577914f69532be"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.5.9"

[[ImageMagick]]
deps = ["FileIO", "ImageCore", "ImageMagick_jll", "InteractiveUtils"]
git-tree-sha1 = "ca8d917903e7a1126b6583a097c5cb7a0bedeac1"
uuid = "6218d12a-5da1-5696-b52f-db25d2ecc6d1"
version = "1.2.2"

[[ImageMagick_jll]]
deps = ["JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pkg", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "1c0a2295cca535fabaf2029062912591e9b61987"
uuid = "c73af94c-d91f-53ed-93a7-00f77d67a9d7"
version = "6.9.10-12+3"

[[ImageMetadata]]
deps = ["AxisArrays", "ColorVectorSpace", "ImageAxes", "ImageCore", "IndirectArrays"]
git-tree-sha1 = "ae76038347dc4edcdb06b541595268fca65b6a42"
uuid = "bc367c6b-8a6b-528e-b4bd-a4b897500b49"
version = "0.9.5"

[[ImageMorphology]]
deps = ["ColorVectorSpace", "ImageCore", "LinearAlgebra", "TiledIteration"]
git-tree-sha1 = "68e7cbcd7dfaa3c2f74b0a8ab3066f5de8f2b71d"
uuid = "787d08f9-d448-5407-9aad-5290dd7ab264"
version = "0.2.11"

[[ImageQualityIndexes]]
deps = ["ColorVectorSpace", "ImageCore", "ImageDistances", "ImageFiltering", "OffsetArrays", "Statistics"]
git-tree-sha1 = "1198f85fa2481a3bb94bf937495ba1916f12b533"
uuid = "2996bd0c-7a13-11e9-2da2-2f5ce47296a9"
version = "0.2.2"

[[ImageShow]]
deps = ["Base64", "FileIO", "ImageCore", "OffsetArrays", "Requires", "StackViews"]
git-tree-sha1 = "832abfd709fa436a562db47fd8e81377f72b01f9"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.1"

[[ImageTransformations]]
deps = ["AxisAlgorithms", "ColorVectorSpace", "CoordinateTransformations", "IdentityRanges", "ImageCore", "Interpolations", "OffsetArrays", "Rotations", "StaticArrays"]
git-tree-sha1 = "e4cc551e4295a5c96545bb3083058c24b78d4cf0"
uuid = "02fcd773-0e25-5acc-982a-7f6622650795"
version = "0.8.13"

[[Images]]
deps = ["AxisArrays", "Base64", "ColorVectorSpace", "FileIO", "Graphics", "ImageAxes", "ImageContrastAdjustment", "ImageCore", "ImageDistances", "ImageFiltering", "ImageIO", "ImageMagick", "ImageMetadata", "ImageMorphology", "ImageQualityIndexes", "ImageShow", "ImageTransformations", "IndirectArrays", "OffsetArrays", "Random", "Reexport", "SparseArrays", "StaticArrays", "Statistics", "StatsBase", "TiledIteration"]
git-tree-sha1 = "8b714d5e11c91a0d945717430ec20f9251af4bd2"
uuid = "916415d5-f1e6-5110-898d-aaa5f9f070e0"
version = "0.24.1"

[[Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "87f7662e03a649cffa2e05bf19c303e168732d3e"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.2+0"

[[IndirectArrays]]
git-tree-sha1 = "c2a145a145dc03a7620af1444e0264ef907bd44f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "0.5.1"

[[Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d979e54b71da82f3a65b62553da4fc3d18c9004c"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2018.0.3+2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[Interpolations]]
deps = ["AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "61aa005707ea2cebf47c8d780da8dc9bc4e0c512"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.13.4"

[[IntervalSets]]
deps = ["Dates", "EllipsisNotation", "Statistics"]
git-tree-sha1 = "3cc368af3f110a767ac786560045dceddfc16758"
uuid = "8197267c-284f-5f27-9208-e0e47529a953"
version = "0.5.3"

[[InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "a7254c0acd8e62f1ac75ad24d5db43f5f19f3c65"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.2"

[[IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[IterTools]]
git-tree-sha1 = "05110a2ab1fc5f932622ffea2a003221f4782c18"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.3.0"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "642a199af8b68253517b80bd3bfd17eb4e84df6e"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.3.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d735490ac75c5cb9f1b00d8b5509c11984dc6943"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.0+0"

[[LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "340e257aada13f95f98ee352d316c3bed37c8ab9"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+0"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "be9eef9f9d78cecb6f262f3c10da151a6c5ab827"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.5"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "5455aef09b40e5020e1520f551fa3135040d4ed0"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2021.1.1+2"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[MappedArrays]]
git-tree-sha1 = "e8b359ef06ec72e8c030463fe02efe5527ee5142"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.1"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "b34e3bc3ca7c94914418637cb10cc4d1d80d877d"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.3"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NaNMath]]
git-tree-sha1 = "bfe47e760d60b82b66b61d2d44128b62e3a369fb"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.5"

[[Netpbm]]
deps = ["ColorVectorSpace", "FileIO", "ImageCore"]
git-tree-sha1 = "09589171688f0039f13ebe0fdcc7288f50228b52"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.0.1"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "043017e0bdeff61cfbb7afeb558ab29536bbb5ed"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.10.8"

[[OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "923319661e9a22712f24596ce81c54fc0366f304"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.1+0"

[[OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "6d105d40e30b635cfed9d52ec29cf456e27d38f8"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.12"

[[PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "646eed6f6a5d8df6708f15ea7e02a7a2c4fe4800"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.10"

[[Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "a7a7e1a88853564e551e4eba8650f8c38df79b37"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.1.1"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "57312c7ecad39566319ccf5aa717a20788eb8c1f"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.18"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00cfd92944ca9c760982747e9a1d0d5d86ab1e5a"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.2"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "afadeba63d90ff223a6a48d2009434ecee2ec9e8"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.1"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[RangeArrays]]
git-tree-sha1 = "b9039e93773ddcfc828f12aadf7115b4b4d225f5"
uuid = "b3c3ace0-ae52-54e7-9d0b-2c1406fd6b9d"
version = "0.3.2"

[[Ratios]]
deps = ["Requires"]
git-tree-sha1 = "01d341f502250e81f6fec0afe662aa861392a3aa"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.2"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[Rotations]]
deps = ["LinearAlgebra", "Random", "StaticArrays", "Statistics"]
git-tree-sha1 = "6a23472b6b097d66da87785b61137142ac104f94"
uuid = "6038ab10-8711-5258-84ad-4b1120ba62dc"
version = "1.0.4"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[SimpleTraits]]
deps = ["InteractiveUtils", "MacroTools"]
git-tree-sha1 = "5d7e3f4e11935503d3ecaf7186eac40602e7d231"
uuid = "699a6c99-e7fa-54fc-8d76-47d257e15c1d"
version = "0.9.4"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "f0bccf98e16759818ffc5d97ac3ebf87eb950150"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "1.8.1"

[[StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[Static]]
deps = ["IfElse"]
git-tree-sha1 = "e7bc80dc93f50857a5d1e3c8121495852f407e6a"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.4.0"

[[StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3c76dde64d03699e074ac02eb2e8ba8254d428da"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.13"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[StatsAPI]]
git-tree-sha1 = "1958272568dc176a1d881acb797beb909c785510"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.0.0"

[[StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "eb35dcc66558b2dda84079b9a1be17557d32091a"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.12"

[[StringDistances]]
deps = ["Distances", "StatsAPI"]
git-tree-sha1 = "00e86048552d34bb486cad935754dd9516bdb46e"
uuid = "88034a9c-02f8-509d-84a9-84ec65e18404"
version = "0.11.1"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[TestImages]]
deps = ["AxisArrays", "ColorTypes", "FileIO", "OffsetArrays", "Pkg", "StringDistances"]
git-tree-sha1 = "f91d170645a8ba6fbaa3ac2879eca5da3d92a31a"
uuid = "5e47fb64-e119-507b-a336-dd2b206d9990"
version = "1.6.2"

[[TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "c342ae2abf4902d65a0b0bf59b28506a6e17078a"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.5.2"

[[TiledIteration]]
deps = ["OffsetArrays"]
git-tree-sha1 = "5683455224ba92ef59db72d10690690f4a8dc297"
uuid = "06e1c1a7-607b-532d-9fad-de7d9aa2abac"
version = "0.3.1"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "cc4bf3fdde8b7e3e9fa0351bdeedba1cf3b7f6e6"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.0+0"

[[libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─e6b6760a-f37f-11ea-3ae1-65443ef5a81a
# ╟─ec66314e-f37f-11ea-0af4-31da0584e881
# ╟─85cfbd10-f384-11ea-31dc-b5693630a4c5
# ╠═33e43c7c-f381-11ea-3abc-c942327456b1
# ╟─938185ec-f384-11ea-21dc-b56b7469f798
# ╠═86e1ee96-f314-11ea-03f6-0f549b79e7c9
# ╠═a4937996-f314-11ea-2ff9-615c888afaa8
# ╠═0d144802-f319-11ea-0028-cd97a776a3d0
# ╟─cc9fcdae-f314-11ea-1b9a-1f68b792f005
# ╟─b49a21a6-f381-11ea-1a98-7f144c55c9b7
# ╟─b49e8cc8-f381-11ea-1056-91668ac6ae4e
# ╠═e799be82-f317-11ea-3ae4-6d13ece3fe10
# ╟─c075a8e6-f382-11ea-2263-cd9507324f4f
# ╠═9cced1a8-f326-11ea-0759-0b2f22e5a1db
# ╠═c5580124-49d9-4991-b42e-2722b7abd29a
# ╠═75539476-a8c1-4098-bff1-d9797fbba074
# ╠═77798078-48c2-4f9a-af92-a209190d3e15
# ╟─c086bd1e-f384-11ea-3b26-2da9e24360ca
# ╟─1d893998-f366-11ea-0828-512de0c44915
# ╟─59991872-f366-11ea-1036-afe313fb4ec1
# ╠═e501ea28-f326-11ea-252a-53949fd9ef57
# ╟─f7915918-f366-11ea-2c46-2f4671ae8a22
# ╠═37d4ea5c-f327-11ea-2cc5-e3774c232c2b
# ╠═67717d02-f327-11ea-0988-bfe661f57f77
# ╟─9e149cd2-f367-11ea-28ef-b9533e8a77bb
# ╟─e3519118-f387-11ea-0c61-e1c2de1c24c1
# ╟─ba1619d4-f389-11ea-2b3f-fd9ba71cf7e3
# ╠═e49235a4-f367-11ea-3913-f54a4a6b2d6b
# ╟─145c0f58-f384-11ea-2b71-09ae83f66da2
# ╟─837c43a4-f368-11ea-00a3-990a45cb0cbd
# ╠═90a22cc6-f327-11ea-1484-7fda90283797
# ╠═3335e07c-f328-11ea-0e6c-8d38c8c0ad5b
# ╟─d4ea4222-f388-11ea-3c8d-db0d651f5282
# ╟─40d6f562-f329-11ea-2ee4-d7806a16ede3
# ╟─4f0975d8-f329-11ea-3d10-59a503f8d6b2
# ╟─dc63d32a-f387-11ea-37e2-6f3666a72e03
# ╟─7eaa57d2-f368-11ea-1a70-c7c7e54bd0b1
# ╠═fd819dac-f368-11ea-33bb-17148387546a
# ╟─d7a9c000-f383-11ea-1516-cf71102d8e94
# ╟─8d558c4c-f328-11ea-0055-730ead5d5c34
# ╟─318a2256-f369-11ea-23a9-2f74c566549b
# ╟─7a44ba52-f318-11ea-0406-4731c80c1007
# ╠═6c7e4b54-f318-11ea-2055-d9f9c0199341
# ╠═74059d04-f319-11ea-29b4-85f5f8f5c610
# ╟─0b9ead92-f318-11ea-3744-37150d649d43
# ╠═d184e9cc-f318-11ea-1a1e-994ab1330c1a
# ╠═cdfb3508-f319-11ea-1486-c5c58a0b9177
# ╠═f010933c-f318-11ea-22c5-4d2e64cd9629
# ╟─5fccc7cc-f369-11ea-3b9e-2f0eca7f0f0e
# ╠═6f37b34c-f31a-11ea-2909-4f2079bf66ec
# ╠═9fa0cd3a-f3e1-11ea-2f7e-bd73b8e3f302
# ╟─f7eba2b6-f388-11ea-06ad-0b861c764d61
# ╟─87afabf8-f317-11ea-3cb3-29dced8e265a
# ╟─8ba9f5fc-f31b-11ea-00fe-79ecece09c25
# ╟─f5a74dfc-f388-11ea-2577-b543d31576c6
# ╟─c3543ea4-f393-11ea-39c8-37747f113b96
# ╟─2f9cbea8-f3a1-11ea-20c6-01fd1464a592
# ╠═abf20aa0-f31b-11ea-2548-9bea4fab4c37
# ╠═b0698d60-72d7-4c74-aa81-97cd97b448fa
# ╠═b479cb8b-616e-40e0-adab-a568d6f648dd
# ╠═405894ee-497b-4ec0-9da6-a2082187c3b7
# ╟─5430d772-f397-11ea-2ed8-03ee06d02a22
# ╟─f580527e-f397-11ea-055f-bb9ea8f12015
# ╟─6f52c1a2-f395-11ea-0c8a-138a77f03803
# ╠═2a7e49b8-f395-11ea-0058-013e51baa554
# ╠═9ba83676-15ae-464d-8943-b83690d5ddbf
# ╠═7ddee6fc-f394-11ea-31fc-5bd665a65bef
# ╟─980b1104-f394-11ea-0948-21002f26ee25
# ╟─9945ae78-f395-11ea-1d78-cf6ad19606c8
# ╟─87efe4c2-f38d-11ea-39cc-bdfa11298317
# ╠═f6571d86-f388-11ea-0390-05592acb9195
# ╠═f626b222-f388-11ea-0d94-1736759b5f52
# ╟─52452d26-f36c-11ea-01a6-313114b4445d
# ╠═2a98f268-f3b6-11ea-1eea-81c28256a19e
# ╟─32e9a944-f3b6-11ea-0e82-1dff6c2eef8d
# ╟─9101d5a0-f371-11ea-1c04-f3f43b96ca4a
# ╠═ddba07dc-f3b7-11ea-353e-0f67713727fc
# ╠═73b52fd6-f3b9-11ea-14ed-ebfcab1ce6aa
# ╠═8ec27ef8-f320-11ea-2573-c97b7b908cb7
# ╟─9f18efe2-f38e-11ea-0871-6d7760d0b2f6
# ╟─a7f3d9f8-f3bb-11ea-0c1a-55bbb8408f09
# ╟─fa8e2772-f3b6-11ea-30f7-699717693164
# ╟─18e0fd8a-f3bc-11ea-0713-fbf74d5fa41a
# ╟─cbf29020-f3ba-11ea-2cb0-b92836f3d04b
# ╟─8bc930f0-f372-11ea-06cb-79ced2834720
# ╠═85033040-f372-11ea-2c31-bb3147de3c0d
# ╠═1d55333c-f393-11ea-229a-5b1e9cabea6a
# ╠═d88bc272-f392-11ea-0efd-15e0e2b2cd4e
# ╠═e66ef06a-f392-11ea-30ab-7160e7723a17
# ╠═36288a21-f065-4bc1-bb15-942a98b9a188
# ╟─c572f6ce-f372-11ea-3c9a-e3a21384edca
# ╠═6d993a5c-f373-11ea-0dde-c94e3bbd1552
# ╟─ea417c2a-f373-11ea-3bb0-b1b5754f2fac
# ╟─56a7f954-f374-11ea-0391-f79b75195f4d
# ╠═b1d09bc8-f320-11ea-26bb-0101c9a204e2
# ╠═3e8b0868-f3bd-11ea-0c15-011bbd6ac051
# ╠═148950fa-ee16-4511-81da-0b071c481fca
# ╠═5ed81be9-a490-40ff-9dfb-b86c97ebc110
# ╠═18f0091a-a0e8-4d80-86a4-4ac32a2a70e4
# ╠═4e3bcf88-f3c5-11ea-3ada-2ff9213647b7
# ╠═4e3ef866-f3c5-11ea-3fb0-27d1ca9a9a3f
# ╠═6e73b1da-f3c5-11ea-145f-6383effe8a89
# ╟─cf39fa2a-f374-11ea-0680-55817de1b837
# ╠═c8724b5e-f3bd-11ea-0034-b92af21ca12d
# ╠═be7d40e2-f320-11ea-1b56-dff2a0a16e8d
# ╟─507f3870-f3c5-11ea-11f6-ada3bb087634
# ╠═50829af6-f3c5-11ea-04a8-0535edd3b0aa
# ╠═9e56ecfa-f3c5-11ea-2e90-3b1839d12038
# ╟─4f48c8b8-f39d-11ea-25d2-1fab031a514f
# ╟─24792456-f37b-11ea-07b2-4f4c8caea633
# ╠═ff055726-f320-11ea-32f6-2bf38d7dd310
# ╠═e287774f-b372-4a44-92ae-dd7ce60c245e
# ╠═36d6e5f3-1e7d-4de8-9295-e45955ed8c7f
# ╟─e0622780-f3b4-11ea-1f44-59fb9c5d2ebd
# ╟─92e19f22-f37b-11ea-25f7-e321337e375e
# ╠═795eb2c4-f37b-11ea-01e1-1dbac3c80c13
# ╠═9eff40fc-8679-4dc2-987b-21c818d53b16
# ╠═51df0c98-f3c5-11ea-25b8-af41dc182bac
# ╠═51e28596-f3c5-11ea-2237-2b72bbfaa001
# ╠═0a10acd8-f3c6-11ea-3e2f-7530a0af8c7f
# ╟─946b69a0-f3a2-11ea-2670-819a5dafe891
# ╟─0fbe2af6-f381-11ea-2f41-23cd1cf930d9
# ╟─48089a00-f321-11ea-1479-e74ba71df067
# ╟─6b4d6584-f3be-11ea-131d-e5bdefcc791b
# ╟─437ba6ce-f37d-11ea-1010-5f6a6e282f9b
# ╟─ef88c388-f388-11ea-3828-ff4db4d1874e
# ╟─ef26374a-f388-11ea-0b4e-67314a9a9094
# ╟─6bdbcf4c-f321-11ea-0288-fb16ff1ec526
# ╟─ffc17f40-f380-11ea-30ee-0fe8563c0eb1
# ╟─ffc40ab2-f380-11ea-2136-63542ff0f386
# ╟─ffceaed6-f380-11ea-3c63-8132d270b83f
# ╟─ffde44ae-f380-11ea-29fb-2dfcc9cda8b4
# ╟─ffe326e0-f380-11ea-3619-61dd0592d409
# ╟─fff5aedc-f380-11ea-2a08-99c230f8fa32
# ╟─00026442-f381-11ea-2b41-bde1fff66011
# ╟─fbf6b0fa-f3e0-11ea-2009-573a218e2460
# ╟─256edf66-f3e1-11ea-206e-4f9b4f6d3a3d
# ╟─00115b6e-f381-11ea-0bc6-61ca119cb628
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
