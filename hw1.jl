### A Pluto.jl notebook ###
# v0.17.0

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 74b008f6-ed6b-11ea-291f-b3791d6d1b35
#begin
	#Pkg.add(["Images", "ImageMagick"])
	#using Images
#end
begin
	import Pkg
	Pkg.add(["Images"])
	using Images
end

# ╔═╡ 6b30dc38-ed6b-11ea-10f3-ab3f121bf4b8
begin
	Pkg.add("PlutoUI")
	using PlutoUI
end

# ╔═╡ 83eb9ca0-ed68-11ea-0bc5-99a09c68f867
md"_homework 1, version 4_"

# ╔═╡ ac8ff080-ed61-11ea-3650-d9df06123e1f
md"""

# **Homework 1** - _convolutions_
`18.S191`, fall 2020

This notebook contains _built-in, live answer checks_! In some exercises you will see a coloured box, which runs a test case on your code, and provides feedback based on the result. Simply edit the code, run it, and the check runs again.

_For MIT students:_ there will also be some additional (secret) test cases that will be run as part of the grading process, and we will look at your notebook and write comments.

Feel free to ask questions!
"""

# ╔═╡ 911ccbce-ed68-11ea-3606-0384e7580d7c
# edit the code below to set your name and kerberos ID (i.e. email without @mit.edu)

student = (name = "Alexey Zaytsev", kerberos_id = "jazz")

# press the ▶ button in the bottom right of this cell to run your edits
# or use Shift+Enter

# you might need to wait until all other cells in this notebook have completed running. 
# scroll down the page to see what's up

# ╔═╡ 8ef13896-ed68-11ea-160b-3550eeabbd7d
md"""

Submission by: **_$(student.name)_** ($(student.kerberos_id)@mit.edu)
"""

# ╔═╡ 5f95e01a-ee0a-11ea-030c-9dba276aba92
md"_Let's create a package environment:_"

# ╔═╡ 67461396-ee0a-11ea-3679-f31d46baa9b4
md"_We set up Images.jl again:_"

# ╔═╡ ab6bbb22-d95e-45c0-8527-3d762895d64d


# ╔═╡ 1808191b-4d98-481d-94a1-61dfee4026c3


# ╔═╡ 540ccfcc-ee0a-11ea-15dc-4f8120063397
md"""
## **Exercise 1** - _Manipulating vectors (1D images)_

A `Vector` is a 1D array. We can think of that as a 1D image.

"""

# ╔═╡ 467856dc-eded-11ea-0f83-13d939021ef3
example_vector = [0.5, 0.4, 0.3, 0.2, 0.1, 0.0, 0.7, 0.0, 0.7, 0.9]

# ╔═╡ ad6a33b0-eded-11ea-324c-cfabfd658b56
md"#### Exerise 1.1
👉 Make a random vector `random_vect` of length 10 using the `rand` function.
"

# ╔═╡ f51333a6-eded-11ea-34e6-bfbb3a69bcb0
random_vect = rand(10) # replace this with your code!

# ╔═╡ cf738088-eded-11ea-2915-61735c2aa990
md"👉 Make a function `mean` using a `for` loop, which computes the mean/average of a vector of numbers."

# ╔═╡ 0ffa8354-edee-11ea-2883-9d5bfea4a236
function mean(x)
	mm = 0
	for xx in x
		mm += xx
	end
	mm /= size(x, 1)
	
	return mm
end

# ╔═╡ 1f104ce4-ee0e-11ea-2029-1d9c817175af
mean([1, 2, 3, 4, 5, 6])

# ╔═╡ 1f229ca4-edee-11ea-2c56-bb00cc6ea53c
md"👉 Define `m` to be the mean of `random_vect`."

# ╔═╡ 2a391708-edee-11ea-124e-d14698171b68
m = mean(random_vect)

# ╔═╡ e2863d4c-edef-11ea-1d67-332ddca03cc4
md"""👉 Write a function `demean`, which takes a vector `x` and subtracts the mean from each value in `x`."""

# ╔═╡ ec5efe8c-edef-11ea-2c6f-afaaeb5bc50c
function demean(x)
	return x .- mean(x)
end

# ╔═╡ 29e10640-edf0-11ea-0398-17dbf4242de3
md"Let's check that the mean of the `demean(random_vect)` is 0:

_Due to floating-point round-off error it may *not* be *exactly* 0._"

# ╔═╡ 6f67657e-ee1a-11ea-0c2f-3d567bcfa6ea
if ismissing(random_vect)
	md"""
	!!! info
	    The following cells error because `random_vect` is not yet defined. Have you done the first exercise?
	"""
end

# ╔═╡ 73ef1d50-edf0-11ea-343c-d71706874c82
copy_of_random_vect = copy(random_vect); # in case demean modifies `x`

# ╔═╡ 38155b5a-edf0-11ea-3e3f-7163da7433fb
mean(demean(copy_of_random_vect))

# ╔═╡ a5f8bafe-edf0-11ea-0da3-3330861ae43a
md"""
#### Exercise 1.2

👉 Generate a vector of 100 zeros. Change the center 20 elements to 1.
"""

# ╔═╡ 491c2c7d-6ed2-4fab-b08a-c5ace500227b
 xx = fill(0, 100)

# ╔═╡ 3389818b-a0d9-4159-8025-b189b32e1191
xx[100 ÷ 2-10:60] .= 1

# ╔═╡ ae7ca464-0d46-459f-830b-d8b10b9122b6
random_vect

# ╔═╡ b6b65b94-edf0-11ea-3686-fbff0ff53d08
function create_bar()
	xx = fill(0, 100)
	xx[100 ÷ 2-10:100 ÷ 2+10] .= 1
	return xx
end

# ╔═╡ 22f28dae-edf2-11ea-25b5-11c369ae1253
md"""
#### Exercise 1.3

👉 Write a function that turns a `Vector` of `Vector`s into a `Matrix`.
"""

# ╔═╡ 8c19fb72-ed6c-11ea-2728-3fa9219eddc4
function vecvec_to_matrix(vecvec)
	println(vecvec)
	mm = zeros(length(vecvec[1]), length(vecvec))

	for i in 1:length(vecvec[1]), j in 1:length(vecvec)
		mm[i, j] = vecvec[j][i]
	end
	return mm
end

# ╔═╡ c4761a7e-edf2-11ea-1e75-118e73dadbed
vecvec_to_matrix([[1,2], [3,4]])

# ╔═╡ 393667ca-edf2-11ea-09c5-c5d292d5e896
md"""


👉 Write a function that turns a `Matrix` into a`Vector` of `Vector`s .
"""

# ╔═╡ 9f1c6d04-ed6c-11ea-007b-75e7e780703d
function matrix_to_vecvec(matrix)
	vv = Vector(undef, size(matrix)[2])
	for i in 1:length(vv)
		vv[i] = matrix[:,i]
	end
	return vv
end

# ╔═╡ 70955aca-ed6e-11ea-2330-89b4d20b1795
matrix_to_vecvec([6 7; 8 9; 10 11])

# ╔═╡ cae4d8a3-58a9-4064-87c2-cb2ff7d17af2
mmm = [6 7; 8 9; 10 11]

# ╔═╡ 5da8cbe8-eded-11ea-2e43-c5b7cc71e133
begin
	colored_line(x::Vector{<:Real}) = Gray.(Float64.((hcat(x)')))
	colored_line(x::Any) = nothing
end

# ╔═╡ 56ced344-eded-11ea-3e81-3936e9ad5777
colored_line(example_vector)

# ╔═╡ b18e2c54-edf1-11ea-0cbf-85946d64b6a2
colored_line(random_vect)

# ╔═╡ d862fb16-edf1-11ea-36ec-615d521e6bc0
colored_line(create_bar())

# ╔═╡ e083b3e8-ed61-11ea-2ec9-217820b0a1b4
md"""
## **Exercise 2** - _Manipulating images_

In this exercise we will get familiar with matrices (2D arrays) in Julia, by manipulating images.
Recall that in Julia images are matrices of `RGB` color objects.

Let's load a picture of Philip again.
"""

# ╔═╡ c5484572-ee05-11ea-0424-f37295c3072d
philip_file = download("https://i.imgur.com/VGPeJ6s.jpg")

# ╔═╡ e86ed944-ee05-11ea-3e0f-d70fc73b789c
md"_Hi there Philip_"

# ╔═╡ c54ccdea-ee05-11ea-0365-23aaf053b7d7
md"""
#### Exercise 2.1
👉 Write a function **`mean_colors`** that accepts an object called `image`. It should calculate the mean (average) amounts of red, green and blue in the image and return a tuple `(r, g, b)` of those means.
"""

# ╔═╡ f6898df6-ee07-11ea-2838-fde9bc739c11
function mean_colors(image)
	r = 0
	g = 0
	b = 0
	for x in image
		r += x.r
		g += x.g
		b += x.b
	end
	r /= length(image)
	b /= length(image)
	g /= length(image)
	
	return (r, g, b)
end

# ╔═╡ d75ec078-ee0d-11ea-3723-71fb8eecb040


# ╔═╡ f68d4a36-ee07-11ea-0832-0360530f102e
md"""
#### Exercise 2.2
👉 Look up the documentation on the `floor` function. Use it to write a function `quantize(x::Number)` that takes in a value $x$ (which you can assume is between 0 and 1) and "quantizes" it into bins of width 0.1. For example, check that 0.267 gets mapped to 0.2.
"""

# ╔═╡ f6991a50-ee07-11ea-0bc4-1d68eb028e6a
begin
	function quantize(x::Number)
		return floor(x, digits=1)
	end
	
	# Exercise 2.3
	function quantize(color::AbstractRGB)
		return	RGBX(floor(color.r, digits=1),
				floor(color.g, digits=1),
				floor(color.b, digits=1))
	end
	
 	# Exercise 2.4
	function quantize(image::AbstractMatrix)
	 	return quantize.(image)
	end
end

# ╔═╡ f6a655f8-ee07-11ea-13b6-43ca404ddfc7
quantize(0.267), quantize(0.91)

# ╔═╡ b8dec210-8a7d-4981-a7fe-07ef78d3112d
tc = RGBX(0.19, 0.19, 0.19)

# ╔═╡ 4fbcf72a-0c49-43fd-831b-6b380ced066c
[quantize(tc) tc]

# ╔═╡ f6b218c0-ee07-11ea-2adb-1968c4fd473a
md"""
#### Exercise 2.3
👉 Write the second **method** of the function `quantize`, i.e. a new *version* of the function with the *same* name. This method will accept a color object called `color`, of the type `AbstractRGB`. 

_Write the function in the same cell as `quantize(x::Number)` from the last exercise. 👆_
    
Here, `::AbstractRGB` is a **type annotation**. This ensures that this version of the function will be chosen when passing in an object whose type is a **subtype** of the `AbstractRGB` abstract type. For example, both the `RGB` and `RGBX` types satisfy this.

The method you write should return a new `RGB` object, in which each component ($r$, $g$ and $b$) are quantized.
"""

# ╔═╡ f6bf64da-ee07-11ea-3efb-05af01b14f67
md"""
#### Exercise 2.4
👉 Write a method `quantize(image::AbstractMatrix)` that quantizes an image by quantizing each pixel in the image. (You may assume that the matrix is a matrix of color objects.)

_Write the function in the same cell as `quantize(x::Number)` from the last exercise. 👆_
"""

# ╔═╡ 25dad7ce-ee0b-11ea-3e20-5f3019dd7fa3
md"Let's apply your method!"

# ╔═╡ f6cc03a0-ee07-11ea-17d8-013991514d42
md"""
#### Exercise 2.5
👉 Write a function `invert` that inverts a color, i.e. sends $(r, g, b)$ to $(1 - r, 1-g, 1-b)$.
"""

# ╔═╡ 63e8d636-ee0b-11ea-173d-bd3327347d55
function invert(color::AbstractRGB)
	return RGBX(1-color.r, 1-color.g, 1-color.b)
end

# ╔═╡ 2cc2f84e-ee0d-11ea-373b-e7ad3204bb00
md"Let's invert some colors:"

# ╔═╡ b8f26960-ee0a-11ea-05b9-3f4bc1099050
black = RGB(0.0, 0.0, 0.0)

# ╔═╡ 5de3a22e-ee0b-11ea-230f-35df4ca3c96d
invert(black)

# ╔═╡ 4e21e0c4-ee0b-11ea-3d65-b311ae3f98e9
red = RGB(0.8, 0.1, 0.1)

# ╔═╡ 6dbf67ce-ee0b-11ea-3b71-abc05a64dc43
invert(red)

# ╔═╡ 846b1330-ee0b-11ea-3579-7d90fafd7290
md"Can you invert the picture of Philip?"

# ╔═╡ f6d6c71a-ee07-11ea-2b63-d759af80707b
md"""
#### Exercise 2.6
👉 Write a function `noisify(x::Number, s)` to add randomness of intensity $s$ to a value $x$, i.e. to add a random value between $-s$ and $+s$ to $x$. If the result falls outside the range $(0, 1)$ you should "clamp" it to that range. (Note that Julia has a `clamp` function, but you should write your own function `myclamp(x)`.)
"""

# ╔═╡ f6e2cb2a-ee07-11ea-06ee-1b77e34c1e91
begin
	function myclamp(x, low, high)
		return min(max(x, low), high)
	end

	
	function noisify(x::Number, s)
		return clamp(x + rand() * 2* s -s, 0, 1)
	end
	
	function noisify(color::AbstractRGB, s)
		return RGB(clamp(color.r + rand() * 2* s -s, 0, 1),
					clamp(color.g + rand() * 2* s -s, 0, 1),
					clamp(color.b + rand() * 2* s -s, 0, 1))
	end
	
	function noisify(image::AbstractMatrix, s)
		return noisify.(image, s)
		
	end
end

# ╔═╡ 7364cc0d-37e3-4869-b441-cc9897278f9f
noisify(0.5, 0.1)

# ╔═╡ f6fc1312-ee07-11ea-39a0-299b67aee3d8
md"""
👉  Write the second method `noisify(c::AbstractRGB, s)` to add random noise of intensity $s$ to each of the $(r, g, b)$ values in a colour. 

_Write the function in the same cell as `noisify(x::Number)` from the last exercise. 👆_
"""

# ╔═╡ 774b4ce6-ee1b-11ea-2b48-e38ee25fc89b
@bind color_noise Slider(0:0.01:1, show_value=true)

# ╔═╡ 7e4aeb70-ee1b-11ea-100f-1952ba66f80f
[red noisify(red, color_noise)]

# ╔═╡ 6a05f568-ee1b-11ea-3b6c-83b6ada3680f


# ╔═╡ f70823d2-ee07-11ea-2bb3-01425212aaf9
md"""
👉 Write the third method `noisify(image::AbstractMatrix, s)` to noisify each pixel of an image.

_Write the function in the same cell as `noisify(x::Number)` from the last exercise. 👆_
"""

# ╔═╡ e70a84d4-ee0c-11ea-0640-bf78653ba102
@bind philip_noise Slider(0:0.01:8, show_value=true)

# ╔═╡ 9604bc44-ee1b-11ea-28f8-7f7af8d0cbb2


# ╔═╡ f714699e-ee07-11ea-08b6-5f5169861b57
md"""
👉 For which noise intensity does it become unrecognisable? 

You may need noise intensities larger than 1. Why?

"""

# ╔═╡ bdc2df7c-ee0c-11ea-2e9f-7d2c085617c1
answer_about_noise_intensity = md"""
The image is almost unrecognisable with intensity 2. With intensity 1 a lot of pixels recieve only moderate distortion, and humans are good at picking patterns in noisy images.
"""

# ╔═╡ 81510a30-ee0e-11ea-0062-8b3327428f9d


# ╔═╡ e3b03628-ee05-11ea-23b6-27c7b0210532
decimate(image, ratio=5) = image[1:ratio:end, 1:ratio:end]

# ╔═╡ c8ecfe5c-ee05-11ea-322b-4b2714898831
philip = let
	original = Images.load(philip_file)
	decimate(original, 8)
end

# ╔═╡ 42db51ab-dac3-4bae-b8ec-cfdac45f0a1d
length(philip)

# ╔═╡ 5be9b144-ee0d-11ea-2a8d-8775de265a1d
mean_colors(philip)

# ╔═╡ 9751586e-ee0c-11ea-0cbb-b7eda92977c9
[philip quantize(philip)]

# ╔═╡ 943103e2-ee0b-11ea-33aa-75a8a1529931
philip_inverted = invert.(philip)

# ╔═╡ ac15e0d0-ee0c-11ea-1eaf-d7f88b5df1d7
noisify(philip, philip_noise)

# ╔═╡ e08781fa-ed61-11ea-13ae-91a49b5eb74a
md"""

## **Exercise 3** - _Convolutions_

As we have seen in the videos, we can produce cool effects using the mathematical technique of **convolutions**. We input one image $M$ and get a new image $M'$ back. 

Conceptually we think of $M$ as a matrix. In practice, in Julia it will be a `Matrix` of color objects, and we may need to take that into account. Ideally, however, we should write a **generic** function that will work for any type of data contained in the matrix.

A convolution works on a small **window** of an image, i.e. a region centered around a given point $(i, j)$. We will suppose that the window is a square region with odd side length $2\ell + 1$, running from $-\ell, \ldots, 0, \ldots, \ell$.

The result of the convolution over a given window, centred at the point $(i, j)$ is a *single number*; this number is the value that we will use for $M'_{i, j}$.
(Note that neighbouring windows overlap.)

To get started let's restrict ourselves to convolutions in 1D.
So a window is just a 1D region from $-\ell$ to $\ell$.

"""

# ╔═╡ 7fc8ee1c-ee09-11ea-1382-ad21d5373308
md"""
---

Let's create a vector `v` of random numbers of length `n=100`.
"""

# ╔═╡ 7fcd6230-ee09-11ea-314f-a542d00d582e
n = 100

# ╔═╡ 7fdb34dc-ee09-11ea-366b-ffe10d1aa845
v = rand(n)

# ╔═╡ 7fe9153e-ee09-11ea-15b3-6f24fcc20734
md"_Feel free to experiment with different values!_"

# ╔═╡ 80108d80-ee09-11ea-0368-31546eb0d3cc
md"""
#### Exercise 3.1
You've seen some colored lines in this notebook to visualize arrays. Can you make another one?

👉 Try plotting our vector `v` using `colored_line(v)`.
"""

# ╔═╡ 01070e28-ee0f-11ea-1928-a7919d452bdd
colored_line(v)

# ╔═╡ 7522f81e-ee1c-11ea-35af-a17eb257ff1a
md"Try changing `n` and `v` around. Notice that you can run the cell `v = rand(n)` again to regenerate new random values."

# ╔═╡ 801d90c0-ee09-11ea-28d6-61b806de26dc
md"""
#### Exercise 3.2
We need to decide how to handle the **boundary conditions**, i.e. what happens if we try to access a position in the vector `v` beyond `1:n`.  The simplest solution is to assume that $v_{i}$ is 0 outside the original vector; however, this may lead to strange boundary effects.
    
A better solution is to use the *closest* value that is inside the vector. Effectively we are extending the vector and copying the extreme values into the extended positions. (Indeed, this is one way we could implement this; these extra positions are called **ghost cells**.)

👉 Write a function `extend(v, i)` that checks whether the position $i$ is inside `1:n`. If so, return the $i$th component of `v`; otherwise, return the nearest end value.
"""

# ╔═╡ 802bec56-ee09-11ea-043e-51cf1db02a34
function extend(v, i)
	if 1 <= i <= length(v)
		return v[i]
	end
	if i < 1
		return v[1]
	end
	return v[end]
	
end

# ╔═╡ b7f3994c-ee1b-11ea-211a-d144db8eafc2
md"_Some test cases:_"

# ╔═╡ 803905b2-ee09-11ea-2d52-e77ff79693b0
extend(v, 1)

# ╔═╡ 80479d98-ee09-11ea-169e-d166eef65874
extend(v, -8)

# ╔═╡ 805691ce-ee09-11ea-053d-6d2e299ee123
extend(v, n + 10)

# ╔═╡ 806e5766-ee0f-11ea-1efc-d753cd83d086
md"Extended with 0:"

# ╔═╡ 38da843a-ee0f-11ea-01df-bfa8b1317d36
colored_line([0, 0, example_vector..., 0, 0])

# ╔═╡ 9bde9f92-ee0f-11ea-27f8-ffef5fce2b3c
md"Extended with your `extend`:"

# ╔═╡ 45c4da9a-ee0f-11ea-2c5b-1f6704559137
if extend(v,1) === missing
	missing
else
	colored_line([extend(example_vector, i) for i in -1:12])
end

# ╔═╡ 80664e8c-ee09-11ea-0702-711bce271315
md"""
#### Exercise 3.3
👉 Write a function `blur_1D(v, l)` that blurs a vector `v` with a window of length `l` by averaging the elements within a window from $-\ell$ to $\ell$. This is called a **box blur**.
"""

# ╔═╡ 807e5662-ee09-11ea-3005-21fdcc36b023
function blur_1D(v, l)
	new_l = copy(v) # is there a better way to get a collection of the same type as v?
	for i in 1:length(v)
		new_l[i] = sum([extend(v, idx) for idx in i-l:i+l]) / (2*l+1)
		println(new_l[i])
	end
	return new_l
end

# ╔═╡ 47f93b61-dcb4-4019-9e2c-499c186f57f2
colored_line(v)

# ╔═╡ b412cd2b-e196-4b23-9b19-361d2e6317a7
colored_line(blur_1D(v, 1))

# ╔═╡ 17b04650-b411-44b1-b465-c3d2ea3dd733
colored_line(blur_1D(v, 2))

# ╔═╡ 7244867c-d928-4306-8d82-25100e59c721
colored_line(blur_1D(v, 4))

# ╔═╡ 809f5330-ee09-11ea-0e5b-415044b6ac1f
md"""
#### Exercise 3.4
👉 Apply the box blur to your vector `v`. Show the original and the new vector by creating two cells that call `colored_line`. Make the parameter $\ell$ interactive, and call it `l_box` instead of just `l` to avoid a variable naming conflict.
"""

# ╔═╡ 808deca8-ee09-11ea-0ee3-1586fa1ce282
let
	try
		test_v = rand(n)
		original = copy(test_v)
		blur_1D(test_v, 5)
		if test_v != original
			md"""
			!!! danger "Oopsie!"
			    It looks like your function _modifies_ `v`. Can you write it without doing so? Maybe you can use `copy`.
			"""
		end
	catch
	end
end

# ╔═╡ ca1ac5f4-ee1c-11ea-3d00-ff5268866f87
@bind window Slider(0:8, show_value=true)

# ╔═╡ c2db75e3-c764-4aec-b6fa-b47d614d7ebc
colored_line(v)

# ╔═╡ 94399d30-cc3d-4432-b23b-7c6981789b6e
colored_line(blur_1D(v, window))

# ╔═╡ 80ab64f4-ee09-11ea-29b4-498112ed0799
md"""
#### Exercise 3.5
The box blur is a simple example of a **convolution**, i.e. a linear function of a window around each point, given by 

$$v'_{i} = \sum_{n}  \, v_{i - n} \, k_{n},$$

where $k$ is a vector called a **kernel**.
    
Again, we need to take care about what happens if $v_{i -n }$ falls off the end of the vector.
    
👉 Write a function `convolve_vector(v, k)` that performs this convolution. You need to think of the vector $k$ as being *centred* on the position $i$. So $n$ in the above formula runs between $-\ell$ and $\ell$, where $2\ell + 1$ is the length of the vector $k$. You will need to do the necessary manipulation of indices.
"""

# ╔═╡ 28e20950-ee0c-11ea-0e0a-b5f2e570b56e
function convolve_vector(v, k)
	l = (length(k) - 1) ÷ 2
	
	new_v = [ sum([extend(v, i-l-1+idx) * k[idx] for idx in 1:length(k)]) for i in 1:length(v)]
	
	return new_v
end

# ╔═╡ f5003cac-ab0d-4f95-8431-773cd0092af1
5 ÷ 2

# ╔═╡ 93284f92-ee12-11ea-0342-833b1a30625c
test_convolution = let
	v = [1, 10, 100, 1000, 10000]
	k = [0, 1, 0]
	convolve_vector(v, k)
end

# ╔═╡ 5eea882c-ee13-11ea-0d56-af81ecd30a4a
colored_line(test_convolution)

# ╔═╡ fcc2cd23-e952-4df4-8908-820a0245acfd
test_convolution1 = let
	v = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
	k = [0, 0, 0.5, 0, 0]
	convolve_vector(v, k)
end

# ╔═╡ 95c532c3-bdb4-4459-b857-c555ad732f37
x = [1, 10, 100]


# ╔═╡ 17ce0c66-6a42-454f-a95a-7c8918d46f3a
result = convolve_vector(x, [0, 1, 1])

# ╔═╡ cf73f9f8-ee12-11ea-39ae-0107e9107ef5
md"_Edit the cell above, or create a new cell with your own test cases!_"

# ╔═╡ 80b7566a-ee09-11ea-3939-6fab470f9ec8
md"""
#### Exercise 3.6
👉 Write a function `gaussian_kernel`.

The definition of a Gaussian in 1D is

$$G(x) = \frac{1}{\sqrt{2\pi \sigma^2}} \exp \left( \frac{-x^2}{2\sigma^2} \right)$$

We need to **sample** (i.e. evaluate) this at each pixel in a region of size $n^2$,
and then **normalize** so that the sum of the resulting kernel is 1.

For simplicity you can take $\sigma=1$.
"""

# ╔═╡ 1c8b4658-ee0c-11ea-2ede-9b9ed7d3125e
begin
function gaussian(n)
	return 1 / (sqrt(2*π))*exp(-n^2 / 2)
end
	
function gaussian_kernel(n)
	# I can't find an elegant way that workd for both even and odd length kernels

	# Also, I'm not sure if I'm supposed to return a kernel length n or n^2. The
	# description says n^2 but that does not make much sense to me, why only
	# kernel with lengths that are square of a number are allowed?
	# Returning leght = n for now, uncommend this to change to n^2

	#n = n^2
	if (n % 2) != 0
		kernel = [ gaussian(i)  for i in -n÷2:n÷2]
	else
		kernel = [gaussian(i) for i in vcat(-n÷2:-1, 1:n÷2)]
	end
	kernel /= sum(kernel) # Divide by the sum of all elements
	return kernel
end

end

# ╔═╡ 0880ac7f-4d76-4068-9ca7-b88d3bb35c70
vcat(1:4, 5:6)

# ╔═╡ 72b00c24-fff6-4063-a422-349b348f470a
colored_line(gaussian_kernel(5))

# ╔═╡ a5520775-5e5f-41a0-a0cc-24c998d7c1cb
gaussian_kernel(3)

# ╔═╡ f8bd22b8-ee14-11ea-04aa-ab16fd01826e
md"Let's test your kernel function!"

# ╔═╡ 2a9dd06a-ee13-11ea-3f84-67bb309c77a8
#gaussian_kernel_size_1D = 3 # change this value, or turn me into a slider!
@bind gaussian_kernel_size_1D Slider(1:30, show_value=true)

# ╔═╡ 38eb92f6-ee13-11ea-14d7-a503ac04302e
test_gauss_1D_a = let
	v = random_vect
	k = gaussian_kernel(gaussian_kernel_size_1D)
	
	if k !== missing
		convolve_vector(v, k)
	end
end

# ╔═╡ b424e2aa-ee14-11ea-33fa-35491e0b9c9d
colored_line(test_gauss_1D_a)

# ╔═╡ 24c21c7c-ee14-11ea-1512-677980db1288
test_gauss_1D_b = let
	v = create_bar()
	k = gaussian_kernel(gaussian_kernel_size_1D)
	
	if k !== missing
		convolve_vector(v, k)
	end
end

# ╔═╡ bc1c20a4-ee14-11ea-3525-63c9fa78f089
colored_line(test_gauss_1D_b)

# ╔═╡ b01858b6-edf3-11ea-0826-938d33c19a43
md"""
 
   
## **Exercise 4** - _Convolutions of images_
    
Now let's move to 2D images. The convolution is then given by a **kernel** matrix $K$:
    
$$M'_{i, j} = \sum_{k, l}  \, M_{i- k, j - l} \, K_{k, l},$$
    
where the sum is over the possible values of $k$ and $l$ in the window. Again we think of the window as being *centered* at $(i, j)$.

A common notation for this operation is $*$:

$$M' = M * K.$$
"""

# ╔═╡ 7c1bc062-ee15-11ea-30b1-1b1e76520f13
md"""
#### Exercise 4.1
👉 Write a function `extend_mat` that takes a matrix `M` and indices `i` and `j`, and returns the closest element of the matrix.
"""

# ╔═╡ 7c2ec6c6-ee15-11ea-2d7d-0d9401a5e5d1
function extend_mat(M::AbstractMatrix, i, j)
	i = max(1, min(i, size(M)[1]))
	j = max(1, min(j, size(M)[2]))
	return M[i, j]
end

# ╔═╡ 9afc4dca-ee16-11ea-354f-1d827aaa61d2
md"_Let's test it!_"

# ╔═╡ cf6b05e2-ee16-11ea-3317-8919565cb56e
small_image = Gray.(rand(5,5))

# ╔═╡ e3616062-ee27-11ea-04a9-b9ec60842a64
md"Extended with `0`:"

# ╔═╡ e5b6cd34-ee27-11ea-0d60-bd4796540b18
[get(small_image, (i, j), Gray(0)) for (i,j) in Iterators.product(-1:7,-1:7)]

# ╔═╡ d06ea762-ee27-11ea-2e9c-1bcff86a3fe0
md"Extended with your `extend`:"

# ╔═╡ e1dc0622-ee16-11ea-274a-3b6ec9e15ab5
[extend_mat(small_image, i, j) for (i,j) in Iterators.product(-1:7,-1:7)]

# ╔═╡ 3cd535e4-ee26-11ea-2482-fb4ad43dda19
let
	philip_head = philip[250:430,110:230]
	[extend_mat(philip_head, i, j) for (i,j) in Iterators.product(-50:size(philip_head,1)+51, (-50:size(philip_head,2)+51))]
end

# ╔═╡ 7c41f0ca-ee15-11ea-05fb-d97a836659af
md"""
#### Exercise 4.2
👉 Implement a function `convolve_image(M, K)`. 
"""

# ╔═╡ 8b96e0bc-ee15-11ea-11cd-cfecea7075a0
function convolve_image(M::AbstractMatrix, K::AbstractMatrix)
	# I don't want to deal with even number of rows/columns.
	# Don't think such kernels are used in practive 
	# and feel like a pain to implement.
	@assert(size(K)[1] % 2 == 1)
	@assert(size(K)[2] % 2 == 1)

	M_conv = copy(M) # Preserve type and dims
	
	for i in 1:size(M)[1], j in 1:size(M)[2]
		M_conv[i, j] = clamp01(sum( [
			K[k_i, k_j] * extend_mat(M,
				i - size(K)[1]÷2 + k_i - 1,
				j - size(K)[2]÷2 + k_j - 1)
			for k_i in 1:size(K)[1], k_j in 1:size(K)[2] 
		] ))

	end
	return M_conv
end

# ╔═╡ edc6f6f6-dcba-4549-ba6e-11af4d70281b
small_image[1,1]=1

# ╔═╡ 59265bd8-10fe-4584-ab80-c60f72391d0f
small_image

# ╔═╡ 5a5135c6-ee1e-11ea-05dc-eb0c683c2ce5
md"_Let's test it out! 🎃_"

# ╔═╡ 577c6daa-ee1e-11ea-1275-b7abc7a27d73
test_image_with_border = [get(small_image, (i, j), Gray(0)) for (i,j) in Iterators.product(-1:7,-1:7)]

# ╔═╡ 275a99c8-ee1e-11ea-0a76-93e3618c9588



K_test = [
	0   0  0
	1/2 0  1/2
	0   0  0
]

# This should give us the original image
# K_test = [
# 	0   0  0
# 	0   1  0
# 	0   0  0
# ]




# ╔═╡ d3ad78a6-2d2d-4611-bd60-103363340a15
sum(K_test)

# ╔═╡ 42dfa206-ee1e-11ea-1fcd-21671042064c
convolve_image(test_image_with_border, K_test)

# ╔═╡ 6e53c2e6-ee1e-11ea-21bd-c9c05381be07
md"_Edit_ `K_test` _to create your own test case!_"

# ╔═╡ e7f8b41a-ee25-11ea-287a-e75d33fbd98b
[philip convolve_image(philip, K_test)]

# ╔═╡ 8a335044-ee19-11ea-0255-b9391246d231
md"""
---

You can create all sorts of effects by choosing the kernel in a smart way. Today, we will implement two special kernels, to produce a **Gaussian blur** and a **Sobel edge detect** filter.

Make sure that you have watched [the lecture](https://www.youtube.com/watch?v=8rrHTtUzyZA) about convolutions!
"""

# ╔═╡ 7c50ea80-ee15-11ea-328f-6b4e4ff20b7e
md"""
#### Exercise 4.3
👉 Apply a **Gaussian blur** to an image.

Here, the 2D Gaussian kernel will be defined as

$$G(x,y)=\frac{1}{2\pi \sigma^2}e^{\frac{-(x^2+y^2)}{2\sigma^2}}$$
"""

# ╔═╡ 0f507282-0492-4a6a-b3ec-9a4de5833352
function gaussian_kernel_2d(σ)
	# Internet suggests cutting off at 3σ . Which I think means
	# kernel shouls be 3σ in each direction from the center:
md"""	
	         ^
	         |
		     3σ
	         |
	| <-3σ-  X  -3σ-> |
	         |
		     3σ
	         |
	         v
"""
	# So each dimension should be 3σ×2+1

	# We don't want any weird even dimensions, so round σ up
	# for dimension calculation only
	kernel = zeros(6*ceil(Int, σ)+1, 6*ceil(Int, σ)+1)
	for i in 1:size(kernel)[1], j in 1:size(kernel)[2]
		x = i - size(kernel)[1]÷2-1
		y = j - size(kernel)[2]÷2-1
		kernel[i, j] = ℯ^(-(x^2+y^2)/2σ^2) / 2*π*σ^2
	end

	return kernel / sum(kernel)
end


# ╔═╡ 3f3b51ea-41c1-440b-a30a-52c1161aa6d5
gaussian_kernel_2d(1.5)

# ╔═╡ 3aaaab5b-b124-4124-88d2-cbfc1f2ed6e6
Kernel.gaussian(1)

# ╔═╡ 160ec6ff-a479-4362-b50b-526724e4243d
md"""This is the function I'm supposed to write for **Exercise 4.3**"""

# ╔═╡ aad67fd0-ee15-11ea-00d4-274ec3cda3a3
function with_gaussian_blur(image::AbstractMatrix)
	kernel = gaussian_kernel_2d(2)
	
	return convolve_image(image, kernel)
end

# ╔═╡ 9e4ddab6-e2ba-4ae1-8c84-3b251dff745f
[philip with_gaussian_blur(philip)]

# ╔═╡ 8ae59674-ee18-11ea-3815-f50713d0fa08
md"_Let's make it interactive. 💫_"

# ╔═╡ 7c6642a6-ee15-11ea-0526-a1aac4286cdd
md"""
#### Exercise 4.4
👉 Create a **Sobel edge detection filter**.

Here, we will need to create two separate filters that separately detect edges in the horizontal and vertical directions:

```math
\begin{align}

G_x &= \left(\begin{bmatrix}
1 \\
2 \\
1 \\
\end{bmatrix} \otimes [1~0~-1]
\right) * A = \begin{bmatrix}
1 & 0 & -1 \\
2 & 0 & -2 \\
1 & 0 & -1 \\
\end{bmatrix}*A\\
G_y &= \left(
\begin{bmatrix}
1 \\
0 \\
-1 \\
\end{bmatrix} \otimes [1~2~1]
\right) * A = \begin{bmatrix}
1 & 2 & 1 \\
0 & 0 & 0 \\
-1 & -2 & -1 \\
\end{bmatrix}*A
\end{align}
```
Here $A$ is the array corresponding to your image.
We can think of these as derivatives in the $x$ and $y$ directions.

Then we combine them by finding the magnitude of the **gradient** (in the sense of multivariate calculus) by defining

$$G_\text{total} = \sqrt{G_x^2 + G_y^2}.$$

For simplicity you can choose one of the "channels" (colours) in the image to apply this to.
"""

# ╔═╡ af940d3e-a08e-4774-8d28-fb3c0aa5614a
begin
	# Yay vectors
	a = [1, 2, 3]
	b = [4, 5, 6]

	a'b

	[1, 2, 3] * [4, 5, 6]'
end

# ╔═╡ b8f86a7b-3cce-4c3e-adc1-131075d4791e
begin

function sobel_filter_x()
	# They look like rows, but verctors are column verctos by default?
	return [1,2,1] * [1, 0, -1]'
end

function sobel_filter_y()
	return [1, 0, -1] * [1, 2, 1]'
end
	
end

# ╔═╡ 8eeae29e-d8a8-4914-9a66-848707ad0187
sobel_filter_x(), sobel_filter_y()

# ╔═╡ 9eeb876c-ee15-11ea-1794-d3ea79f47b75
function with_sobel_edge_detect(image)
	G_x_r = convolve_image(channelview(image)[1,:,:], sobel_filter_x())
	G_x_g = convolve_image(channelview(image)[2,:,:], sobel_filter_x())
	G_x_b = convolve_image(channelview(image)[3,:,:], sobel_filter_x())

    G_y_r = convolve_image(channelview(image)[1,:,:], sobel_filter_y())
	G_y_g = convolve_image(channelview(image)[2,:,:], sobel_filter_y())
	G_y_b = convolve_image(channelview(image)[3,:,:], sobel_filter_y())

	# highest edge value of all channels. This took a while to figure out.
	G_max_x = broadcast(max, G_x_r, G_x_g, G_x_b)
	G_max_y = broadcast(max, G_y_r, G_y_g, G_y_b)

	# Average edge value of all channels.
	G_avg_x = (G_x_r + G_x_g + G_x_b) ./ 3
	G_avg_y = (G_y_r + G_y_g + G_y_b) ./ 3

	# 2D gradients or max and avg edges
	G_max_tot = sqrt.(G_max_x.^2 .+ G_max_y.^2)
	G_avg_tot = sqrt.(G_avg_x.^2 .+ G_avg_y.^2)

	# And each channel separately
	G_r_tot = sqrt.(G_x_r.^2 .+ G_y_r.^2)
	G_g_tot = sqrt.(G_x_g.^2 .+ G_y_g.^2)
	G_b_tot = sqrt.(G_x_b.^2 .+ G_y_b.^2)
	
	return (Gray.(G_max_tot), Gray.(G_avg_tot), Gray.(G_r_tot), Gray.(G_g_tot), Gray.(G_b_tot))
end

# ╔═╡ ca72e862-587c-4d54-9437-3b3cc2d5ecb1
# Top row: Original, max channel edges, average channel edge
# Bottom : Red edges, Green edges, Blue edges.

[philip with_sobel_edge_detect(philip)[1] with_sobel_edge_detect(philip)[2]
with_sobel_edge_detect(philip)[3] with_sobel_edge_detect(philip)[4] with_sobel_edge_detect(philip)[5]]


# ╔═╡ 40dbf222-5824-4126-b821-118aab847202
begin
	A = [ 1 2 3 ]
	B = [ 3 2 1 ]
	C = [ 4 1 2 ]

	broadcast(max, A, B,C)
end

# ╔═╡ 1ff6b5cc-ee19-11ea-2ca8-7f00c204f587
#sobel_camera_image = Gray.(process_raw_camera_data(sobel_raw_camera_data));

# ╔═╡ 1b85ee76-ee10-11ea-36d7-978340ef61e6
md"""
## **Exercise 5** - _Lecture transcript_
_(MIT students only)_

Please see the Canvas post for transcript document for week 1 [here](https://canvas.mit.edu/courses/5637/discussion_topics/27880).

We need each of you to correct about 100 lines (see instructions in the beginning of the document.)

👉 Please mention the name of the video and the line ranges you edited:
"""

# ╔═╡ 477d0a3c-ee10-11ea-11cf-07b0e0ce6818
lines_i_edited = md"""
Convolution, lines 100-0 (_for example_)
"""

# ╔═╡ 8ffe16ce-ee20-11ea-18bd-15640f94b839
if student.kerberos_id === "jazz"
	md"""
!!! danger "Oops!"
    **Before you submit**, remember to fill in your name and kerberos ID at the top of this notebook!
	"""
end

# ╔═╡ 5516c800-edee-11ea-12cf-3f8c082ef0ef
hint(text) = Markdown.MD(Markdown.Admonition("hint", "Hint", [text]))

# ╔═╡ b1d5ca28-edf6-11ea-269e-75a9fb549f1d
hint(md"You can find out more about any function (like `rand`) by creating a new cell and typing:
	
```
?rand
```

Once the Live Docs are open, you can select any code to learn more about it. It might be useful to leave it open all the time, and get documentation while you type code.")

# ╔═╡ f6ef2c2e-ee07-11ea-13a8-2512e7d94426
hint(md"The `rand` function generates (uniform) random floating-point numbers between $0$ and $1$.")

# ╔═╡ ea435e58-ee11-11ea-3785-01af8dd72360
hint(md"Have a look at Exercise 2 to see an example of adding interactivity with a slider. You can read the [Interactivity](./sample/Interactivity.jl) and the [PlutoUI](./sample/PlutoUI.jl) sample notebooks _(right click -> Open in new tab)_ to learn more.")

# ╔═╡ e9aadeee-ee1d-11ea-3525-95f6ba5fda31
hint(md"`l = (length(k) - 1) ÷ 2`")

# ╔═╡ 649df270-ee24-11ea-397e-79c4355e38db
hint(md"`num_rows, num_columns = size(M)`")

# ╔═╡ 0cabed84-ee1e-11ea-11c1-7d8a4b4ad1af
hint(md"`num_rows, num_columns = size(K)`")

# ╔═╡ 57360a7a-edee-11ea-0c28-91463ece500d
almost(text) = Markdown.MD(Markdown.Admonition("warning", "Almost there!", [text]))

# ╔═╡ dcb8324c-edee-11ea-17ff-375ff5078f43
still_missing(text=md"Replace `missing` with your answer.") = Markdown.MD(Markdown.Admonition("warning", "Here we go!", [text]))

# ╔═╡ 58af703c-edee-11ea-2963-f52e78fc2412
keep_working(text=md"The answer is not quite right.") = Markdown.MD(Markdown.Admonition("danger", "Keep working on it!", [text]))

# ╔═╡ f3d00a9a-edf3-11ea-07b3-1db5c6d0b3cf
yays = [md"Great!", md"Yay ❤", md"Great! 🎉", md"Well done!", md"Keep it up!", md"Good job!", md"Awesome!", md"You got the right answer!", md"Let's move on to the next section."]

# ╔═╡ 5aa9dfb2-edee-11ea-3754-c368fb40637c
correct(text=rand(yays)) = Markdown.MD(Markdown.Admonition("correct", "Got it!", [text]))

# ╔═╡ 74d44e22-edee-11ea-09a0-69aa0aba3281
not_defined(variable_name) = Markdown.MD(Markdown.Admonition("danger", "Oopsie!", [md"Make sure that you define a variable called **$(Markdown.Code(string(variable_name)))**"]))

# ╔═╡ 397941fc-edee-11ea-33f2-5d46c759fbf7
if !@isdefined(random_vect)
	not_defined(:random_vect)
elseif ismissing(random_vect)
	still_missing()
elseif !(random_vect isa Vector)
	keep_working(md"`random_vect` should be a `Vector`.")
elseif length(random_vect) != 10
	keep_working(md"`random_vect` does not have the correct size.")
else
	correct()
end

# ╔═╡ 38dc80a0-edef-11ea-10e9-615255a4588c
if !@isdefined(mean)
	not_defined(:mean)
else
	let
		result = mean([1,2,3])
		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif result != 2
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 2b1ccaca-edee-11ea-34b0-c51659f844d0
if !@isdefined(m)
	not_defined(:m)
elseif ismissing(m)
	still_missing()
elseif !(m isa Number)
	keep_working(md"`m` should be a number.")
elseif m != mean(random_vect)
	keep_working()
else
	correct()
end

# ╔═╡ e3394c8a-edf0-11ea-1bb8-619f7abb6881
if !@isdefined(create_bar)
	not_defined(:create_bar)
else
	let
		result = create_bar()
		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif !(result isa Vector) || length(result) != 100
			keep_working(md"The result should be a `Vector` with 100 elements.")
		elseif result[[1,50,100]] != [0,1,0]
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ adfbe9b2-ed6c-11ea-09ac-675262f420df
if !@isdefined(vecvec_to_matrix)
	not_defined(:vecvec_to_matrix)
else
	let
		input = [[6,7],[8,9]]

		result = vecvec_to_matrix(input)
		shouldbe = [6 7; 8 9]

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif !(result isa Matrix)
			keep_working(md"The result should be a `Matrix`")
		elseif result != shouldbe && result != shouldbe'
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ e06b7fbc-edf2-11ea-1708-fb32599dded3
if !@isdefined(matrix_to_vecvec)
	not_defined(:matrix_to_vecvec)
else
	let
		input = [6 7 8; 8 9 10]
		result = matrix_to_vecvec(input)
		shouldbe = [[6,7,8],[8,9,10]]
		shouldbe2 = [[6,8], [7,9], [8,10]]

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif result != shouldbe && result != shouldbe2
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 4d0158d0-ee0d-11ea-17c3-c169d4284acb
if !@isdefined(mean_colors)
	not_defined(:mean_colors)
else
	let
		input = reshape([RGB(1.0, 1.0, 1.0), RGB(1.0, 1.0, 0.0)], (2,1))
		
		result = mean_colors(input)
		shouldbe = (1.0, 1.0, 0.5)
		shouldbe2 = RGB(shouldbe...)

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif !(result == shouldbe) && !(result == shouldbe2)
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ c905b73e-ee1a-11ea-2e36-23b8e73bfdb6
if !@isdefined(quantize)
	not_defined(:quantize)
else
	let
		result = quantize(.3)

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif result != .3
			if quantize(0.35) == .3
				almost(md"What should quantize(`0.2`) be?")
			else
				keep_working()
			end
		else
			correct()
		end
	end
end

# ╔═╡ bcf98dfc-ee1b-11ea-21d0-c14439500971
if !@isdefined(extend)
	not_defined(:extend)
else
	let
		result = extend([6,7],-10)

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif result != 6 || extend([6,7],10) != 7
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 7ffd14f8-ee1d-11ea-0343-b54fb0333aea
if !@isdefined(convolve_vector)
	not_defined(:convolve_vector)
else
	let
		x = [1, 10, 100]
		result = convolve_vector(x, [0, 1, 1])
		shouldbe = [11, 110, 200]
		shouldbe2 = [2, 11, 110]

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif !(result isa AbstractVector)
			keep_working(md"The returned object is not a `Vector`.")
		elseif size(result) != size(x)
			keep_working(md"The returned vector has the wrong dimensions.")
		elseif result != shouldbe && result != shouldbe2
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ efd1ceb4-ee1c-11ea-350e-f7e3ea059024
if !@isdefined(extend_mat)
	not_defined(:extend_mat)
else
	let
		input = [42 37; 1 0]
		result = extend_mat(input, -2, -2)

		if ismissing(result)
			still_missing()
		elseif isnothing(result)
			keep_working(md"Did you forget to write `return`?")
		elseif result != 42 || extend_mat(input, -1, 3) != 37
			keep_working()
		else
			correct()
		end
	end
end

# ╔═╡ 115ded8c-ee0a-11ea-3493-89487315feb7
bigbreak = html"<br><br><br><br><br>";

# ╔═╡ 54056a02-ee0a-11ea-101f-47feb6623bec
bigbreak

# ╔═╡ 45815734-ee0a-11ea-2982-595e1fc0e7b1
bigbreak

# ╔═╡ 4139ee66-ee0a-11ea-2282-15d63bcca8b8
bigbreak

# ╔═╡ 27847dc4-ee0a-11ea-0651-ebbbb3cfd58c
bigbreak

# ╔═╡ 0001f782-ee0e-11ea-1fb4-2b5ef3d241e2
bigbreak

# ╔═╡ 91f4778e-ee20-11ea-1b7e-2b0892bd3c0f
bigbreak

# ╔═╡ 5842895a-ee10-11ea-119d-81e4c4c8c53b
bigbreak

# ╔═╡ dfb7c6be-ee0d-11ea-194e-9758857f7b20
function camera_input(;max_size=200, default_url="https://i.imgur.com/SUmi94P.png")
"""
<span class="pl-image waiting-for-permission">
<style>
	
	.pl-image.popped-out {
		position: fixed;
		top: 0;
		right: 0;
		z-index: 5;
	}

	.pl-image #video-container {
		width: 250px;
	}

	.pl-image video {
		border-radius: 1rem 1rem 0 0;
	}
	.pl-image.waiting-for-permission #video-container {
		display: none;
	}
	.pl-image #prompt {
		display: none;
	}
	.pl-image.waiting-for-permission #prompt {
		width: 250px;
		height: 200px;
		display: grid;
		place-items: center;
		font-family: monospace;
		font-weight: bold;
		text-decoration: underline;
		cursor: pointer;
		border: 5px dashed rgba(0,0,0,.5);
	}

	.pl-image video {
		display: block;
	}
	.pl-image .bar {
		width: inherit;
		display: flex;
		z-index: 6;
	}
	.pl-image .bar#top {
		position: absolute;
		flex-direction: column;
	}
	
	.pl-image .bar#bottom {
		background: black;
		border-radius: 0 0 1rem 1rem;
	}
	.pl-image .bar button {
		flex: 0 0 auto;
		background: rgba(255,255,255,.8);
		border: none;
		width: 2rem;
		height: 2rem;
		border-radius: 100%;
		cursor: pointer;
		z-index: 7;
	}
	.pl-image .bar button#shutter {
		width: 3rem;
		height: 3rem;
		margin: -1.5rem auto .2rem auto;
	}

	.pl-image video.takepicture {
		animation: pictureflash 200ms linear;
	}

	@keyframes pictureflash {
		0% {
			filter: grayscale(1.0) contrast(2.0);
		}

		100% {
			filter: grayscale(0.0) contrast(1.0);
		}
	}
</style>

	<div id="video-container">
		<div id="top" class="bar">
			<button id="stop" title="Stop video">✖</button>
			<button id="pop-out" title="Pop out/pop in">⏏</button>
		</div>
		<video playsinline autoplay></video>
		<div id="bottom" class="bar">
		<button id="shutter" title="Click to take a picture">📷</button>
		</div>
	</div>
		
	<div id="prompt">
		<span>
		Enable webcam
		</span>
	</div>

<script>
	// based on https://github.com/fonsp/printi-static (by the same author)
	const span = (this?.currentScript ?? currentScript).parentElement
	const video = span.querySelector("video")
	const popout = span.querySelector("button#pop-out")
	const stop = span.querySelector("button#stop")
	const shutter = span.querySelector("button#shutter")
	const prompt = span.querySelector(".pl-image #prompt")

	const maxsize = $(max_size)

	const send_source = (source, src_width, src_height) => {
		const scale = Math.min(1.0, maxsize / src_width, maxsize / src_height)

		const width = Math.floor(src_width * scale)
		const height = Math.floor(src_height * scale)

		const canvas = html`<canvas width=\${width} height=\${height}>`
		const ctx = canvas.getContext("2d")
		ctx.drawImage(source, 0, 0, width, height)

		span.value = {
			width: width,
			height: height,
			data: ctx.getImageData(0, 0, width, height).data,
		}
		span.dispatchEvent(new CustomEvent("input"))
	}
	
	const clear_camera = () => {
		window.stream.getTracks().forEach(s => s.stop());
		video.srcObject = null;

		span.classList.add("waiting-for-permission");
	}

	prompt.onclick = () => {
		navigator.mediaDevices.getUserMedia({
			audio: false,
			video: {
				facingMode: "environment",
			},
		}).then(function(stream) {

			stream.onend = console.log

			window.stream = stream
			video.srcObject = stream
			window.cameraConnected = true
			video.controls = false
			video.play()
			video.controls = false

			span.classList.remove("waiting-for-permission");

		}).catch(function(error) {
			console.log(error)
		});
	}
	stop.onclick = () => {
		clear_camera()
	}
	popout.onclick = () => {
		span.classList.toggle("popped-out")
	}

	shutter.onclick = () => {
		const cl = video.classList
		cl.remove("takepicture")
		void video.offsetHeight
		cl.add("takepicture")
		video.play()
		video.controls = false
		console.log(video)
		send_source(video, video.videoWidth, video.videoHeight)
	}
	
	
	document.addEventListener("visibilitychange", () => {
		if (document.visibilityState != "visible") {
			clear_camera()
		}
	})


	// Set a default image

	const img = html`<img crossOrigin="anonymous">`

	img.onload = () => {
	console.log("helloo")
		send_source(img, img.width, img.height)
	}
	img.src = "$(default_url)"
	console.log(img)
</script>
</span>
""" |> HTML
end

# ╔═╡ 94c0798e-ee18-11ea-3212-1533753eabb6
@bind gauss_raw_camera_data camera_input(;max_size=100)

# ╔═╡ 1a0324de-ee19-11ea-1d4d-db37f4136ad3
@bind sobel_raw_camera_data camera_input()

# ╔═╡ e15ad330-ee0d-11ea-25b6-1b1b3f3d7888

function process_raw_camera_data(raw_camera_data)
	# the raw image data is a long byte array, we need to transform it into something
	# more "Julian" - something with more _structure_.
	
	# The encoding of the raw byte stream is:
	# every 4 bytes is a single pixel
	# every pixel has 4 values: Red, Green, Blue, Alpha
	# (we ignore alpha for this notebook)
	
	# So to get the red values for each pixel, we take every 4th value, starting at 
	# the 1st:
	reds_flat = UInt8.(raw_camera_data["data"][1:4:end])
	greens_flat = UInt8.(raw_camera_data["data"][2:4:end])
	blues_flat = UInt8.(raw_camera_data["data"][3:4:end])
	
	# but these are still 1-dimensional arrays, nicknamed 'flat' arrays
	# We will 'reshape' this into 2D arrays:
	
	width = raw_camera_data["width"]
	height = raw_camera_data["height"]
	
	# shuffle and flip to get it in the right shape
	reds = reshape(reds_flat, (width, height))' / 255.0
	greens = reshape(greens_flat, (width, height))' / 255.0
	blues = reshape(blues_flat, (width, height))' / 255.0
	
	# we have our 2D array for each color
	# Let's create a single 2D array, where each value contains the R, G and B value of 
	# that pixel
	
	RGB.(reds, greens, blues)
end

# ╔═╡ f461f5f2-ee18-11ea-3d03-95f57f9bf09e
gauss_camera_image = process_raw_camera_data(gauss_raw_camera_data);

# ╔═╡ a75701c4-ee18-11ea-2863-d3042e71a68b
with_gaussian_blur(gauss_camera_image)

# ╔═╡ 0aed3a2b-fb99-47f7-8f97-75c6ac0600e2
sobel_camera_image = process_raw_camera_data(sobel_raw_camera_data);

# ╔═╡ 22781bf6-f2cd-477f-9580-95508bebfa5c
sobel_camera_image

# ╔═╡ 1bf94c00-ee19-11ea-0e3c-e12bc68d8e28
[sobel_camera_image with_sobel_edge_detect(sobel_camera_image)[1] with_sobel_edge_detect(sobel_camera_image)[2]]

# ╔═╡ Cell order:
# ╠═83eb9ca0-ed68-11ea-0bc5-99a09c68f867
# ╟─8ef13896-ed68-11ea-160b-3550eeabbd7d
# ╟─ac8ff080-ed61-11ea-3650-d9df06123e1f
# ╠═911ccbce-ed68-11ea-3606-0384e7580d7c
# ╟─5f95e01a-ee0a-11ea-030c-9dba276aba92
# ╟─67461396-ee0a-11ea-3679-f31d46baa9b4
# ╠═74b008f6-ed6b-11ea-291f-b3791d6d1b35
# ╠═ab6bbb22-d95e-45c0-8527-3d762895d64d
# ╠═1808191b-4d98-481d-94a1-61dfee4026c3
# ╟─54056a02-ee0a-11ea-101f-47feb6623bec
# ╟─540ccfcc-ee0a-11ea-15dc-4f8120063397
# ╟─467856dc-eded-11ea-0f83-13d939021ef3
# ╠═56ced344-eded-11ea-3e81-3936e9ad5777
# ╟─ad6a33b0-eded-11ea-324c-cfabfd658b56
# ╠═f51333a6-eded-11ea-34e6-bfbb3a69bcb0
# ╟─b18e2c54-edf1-11ea-0cbf-85946d64b6a2
# ╟─397941fc-edee-11ea-33f2-5d46c759fbf7
# ╟─b1d5ca28-edf6-11ea-269e-75a9fb549f1d
# ╟─cf738088-eded-11ea-2915-61735c2aa990
# ╠═0ffa8354-edee-11ea-2883-9d5bfea4a236
# ╠═1f104ce4-ee0e-11ea-2029-1d9c817175af
# ╟─38dc80a0-edef-11ea-10e9-615255a4588c
# ╟─1f229ca4-edee-11ea-2c56-bb00cc6ea53c
# ╠═2a391708-edee-11ea-124e-d14698171b68
# ╟─2b1ccaca-edee-11ea-34b0-c51659f844d0
# ╟─e2863d4c-edef-11ea-1d67-332ddca03cc4
# ╠═ec5efe8c-edef-11ea-2c6f-afaaeb5bc50c
# ╟─29e10640-edf0-11ea-0398-17dbf4242de3
# ╟─6f67657e-ee1a-11ea-0c2f-3d567bcfa6ea
# ╠═38155b5a-edf0-11ea-3e3f-7163da7433fb
# ╠═73ef1d50-edf0-11ea-343c-d71706874c82
# ╟─a5f8bafe-edf0-11ea-0da3-3330861ae43a
# ╠═491c2c7d-6ed2-4fab-b08a-c5ace500227b
# ╠═3389818b-a0d9-4159-8025-b189b32e1191
# ╠═ae7ca464-0d46-459f-830b-d8b10b9122b6
# ╠═b6b65b94-edf0-11ea-3686-fbff0ff53d08
# ╟─d862fb16-edf1-11ea-36ec-615d521e6bc0
# ╟─e3394c8a-edf0-11ea-1bb8-619f7abb6881
# ╟─22f28dae-edf2-11ea-25b5-11c369ae1253
# ╠═8c19fb72-ed6c-11ea-2728-3fa9219eddc4
# ╠═c4761a7e-edf2-11ea-1e75-118e73dadbed
# ╟─adfbe9b2-ed6c-11ea-09ac-675262f420df
# ╟─393667ca-edf2-11ea-09c5-c5d292d5e896
# ╠═9f1c6d04-ed6c-11ea-007b-75e7e780703d
# ╠═70955aca-ed6e-11ea-2330-89b4d20b1795
# ╠═cae4d8a3-58a9-4064-87c2-cb2ff7d17af2
# ╟─e06b7fbc-edf2-11ea-1708-fb32599dded3
# ╟─5da8cbe8-eded-11ea-2e43-c5b7cc71e133
# ╟─45815734-ee0a-11ea-2982-595e1fc0e7b1
# ╟─e083b3e8-ed61-11ea-2ec9-217820b0a1b4
# ╠═c5484572-ee05-11ea-0424-f37295c3072d
# ╠═c8ecfe5c-ee05-11ea-322b-4b2714898831
# ╟─e86ed944-ee05-11ea-3e0f-d70fc73b789c
# ╟─c54ccdea-ee05-11ea-0365-23aaf053b7d7
# ╠═42db51ab-dac3-4bae-b8ec-cfdac45f0a1d
# ╠═f6898df6-ee07-11ea-2838-fde9bc739c11
# ╠═5be9b144-ee0d-11ea-2a8d-8775de265a1d
# ╟─4d0158d0-ee0d-11ea-17c3-c169d4284acb
# ╠═d75ec078-ee0d-11ea-3723-71fb8eecb040
# ╟─f68d4a36-ee07-11ea-0832-0360530f102e
# ╠═f6991a50-ee07-11ea-0bc4-1d68eb028e6a
# ╠═f6a655f8-ee07-11ea-13b6-43ca404ddfc7
# ╠═b8dec210-8a7d-4981-a7fe-07ef78d3112d
# ╠═4fbcf72a-0c49-43fd-831b-6b380ced066c
# ╟─c905b73e-ee1a-11ea-2e36-23b8e73bfdb6
# ╟─f6b218c0-ee07-11ea-2adb-1968c4fd473a
# ╟─f6bf64da-ee07-11ea-3efb-05af01b14f67
# ╟─25dad7ce-ee0b-11ea-3e20-5f3019dd7fa3
# ╠═9751586e-ee0c-11ea-0cbb-b7eda92977c9
# ╟─f6cc03a0-ee07-11ea-17d8-013991514d42
# ╠═63e8d636-ee0b-11ea-173d-bd3327347d55
# ╟─2cc2f84e-ee0d-11ea-373b-e7ad3204bb00
# ╟─b8f26960-ee0a-11ea-05b9-3f4bc1099050
# ╠═5de3a22e-ee0b-11ea-230f-35df4ca3c96d
# ╠═4e21e0c4-ee0b-11ea-3d65-b311ae3f98e9
# ╠═6dbf67ce-ee0b-11ea-3b71-abc05a64dc43
# ╟─846b1330-ee0b-11ea-3579-7d90fafd7290
# ╠═943103e2-ee0b-11ea-33aa-75a8a1529931
# ╟─f6d6c71a-ee07-11ea-2b63-d759af80707b
# ╠═f6e2cb2a-ee07-11ea-06ee-1b77e34c1e91
# ╠═7364cc0d-37e3-4869-b441-cc9897278f9f
# ╟─f6ef2c2e-ee07-11ea-13a8-2512e7d94426
# ╟─f6fc1312-ee07-11ea-39a0-299b67aee3d8
# ╟─774b4ce6-ee1b-11ea-2b48-e38ee25fc89b
# ╠═7e4aeb70-ee1b-11ea-100f-1952ba66f80f
# ╟─6a05f568-ee1b-11ea-3b6c-83b6ada3680f
# ╟─f70823d2-ee07-11ea-2bb3-01425212aaf9
# ╠═e70a84d4-ee0c-11ea-0640-bf78653ba102
# ╠═ac15e0d0-ee0c-11ea-1eaf-d7f88b5df1d7
# ╟─9604bc44-ee1b-11ea-28f8-7f7af8d0cbb2
# ╟─f714699e-ee07-11ea-08b6-5f5169861b57
# ╠═bdc2df7c-ee0c-11ea-2e9f-7d2c085617c1
# ╟─81510a30-ee0e-11ea-0062-8b3327428f9d
# ╠═6b30dc38-ed6b-11ea-10f3-ab3f121bf4b8
# ╟─e3b03628-ee05-11ea-23b6-27c7b0210532
# ╟─4139ee66-ee0a-11ea-2282-15d63bcca8b8
# ╟─e08781fa-ed61-11ea-13ae-91a49b5eb74a
# ╟─7fc8ee1c-ee09-11ea-1382-ad21d5373308
# ╠═7fcd6230-ee09-11ea-314f-a542d00d582e
# ╠═7fdb34dc-ee09-11ea-366b-ffe10d1aa845
# ╟─7fe9153e-ee09-11ea-15b3-6f24fcc20734
# ╟─80108d80-ee09-11ea-0368-31546eb0d3cc
# ╠═01070e28-ee0f-11ea-1928-a7919d452bdd
# ╟─7522f81e-ee1c-11ea-35af-a17eb257ff1a
# ╟─801d90c0-ee09-11ea-28d6-61b806de26dc
# ╠═802bec56-ee09-11ea-043e-51cf1db02a34
# ╟─b7f3994c-ee1b-11ea-211a-d144db8eafc2
# ╠═803905b2-ee09-11ea-2d52-e77ff79693b0
# ╠═80479d98-ee09-11ea-169e-d166eef65874
# ╠═805691ce-ee09-11ea-053d-6d2e299ee123
# ╟─806e5766-ee0f-11ea-1efc-d753cd83d086
# ╟─38da843a-ee0f-11ea-01df-bfa8b1317d36
# ╟─9bde9f92-ee0f-11ea-27f8-ffef5fce2b3c
# ╟─45c4da9a-ee0f-11ea-2c5b-1f6704559137
# ╟─bcf98dfc-ee1b-11ea-21d0-c14439500971
# ╟─80664e8c-ee09-11ea-0702-711bce271315
# ╠═807e5662-ee09-11ea-3005-21fdcc36b023
# ╠═47f93b61-dcb4-4019-9e2c-499c186f57f2
# ╠═b412cd2b-e196-4b23-9b19-361d2e6317a7
# ╠═17b04650-b411-44b1-b465-c3d2ea3dd733
# ╠═7244867c-d928-4306-8d82-25100e59c721
# ╟─809f5330-ee09-11ea-0e5b-415044b6ac1f
# ╟─808deca8-ee09-11ea-0ee3-1586fa1ce282
# ╠═ca1ac5f4-ee1c-11ea-3d00-ff5268866f87
# ╠═c2db75e3-c764-4aec-b6fa-b47d614d7ebc
# ╠═94399d30-cc3d-4432-b23b-7c6981789b6e
# ╟─ea435e58-ee11-11ea-3785-01af8dd72360
# ╟─80ab64f4-ee09-11ea-29b4-498112ed0799
# ╠═28e20950-ee0c-11ea-0e0a-b5f2e570b56e
# ╠═f5003cac-ab0d-4f95-8431-773cd0092af1
# ╟─e9aadeee-ee1d-11ea-3525-95f6ba5fda31
# ╟─5eea882c-ee13-11ea-0d56-af81ecd30a4a
# ╠═93284f92-ee12-11ea-0342-833b1a30625c
# ╠═fcc2cd23-e952-4df4-8908-820a0245acfd
# ╠═95c532c3-bdb4-4459-b857-c555ad732f37
# ╠═17ce0c66-6a42-454f-a95a-7c8918d46f3a
# ╟─cf73f9f8-ee12-11ea-39ae-0107e9107ef5
# ╠═7ffd14f8-ee1d-11ea-0343-b54fb0333aea
# ╟─80b7566a-ee09-11ea-3939-6fab470f9ec8
# ╠═1c8b4658-ee0c-11ea-2ede-9b9ed7d3125e
# ╠═0880ac7f-4d76-4068-9ca7-b88d3bb35c70
# ╠═72b00c24-fff6-4063-a422-349b348f470a
# ╠═a5520775-5e5f-41a0-a0cc-24c998d7c1cb
# ╟─f8bd22b8-ee14-11ea-04aa-ab16fd01826e
# ╠═2a9dd06a-ee13-11ea-3f84-67bb309c77a8
# ╠═b424e2aa-ee14-11ea-33fa-35491e0b9c9d
# ╠═38eb92f6-ee13-11ea-14d7-a503ac04302e
# ╟─bc1c20a4-ee14-11ea-3525-63c9fa78f089
# ╠═24c21c7c-ee14-11ea-1512-677980db1288
# ╟─27847dc4-ee0a-11ea-0651-ebbbb3cfd58c
# ╟─b01858b6-edf3-11ea-0826-938d33c19a43
# ╟─7c1bc062-ee15-11ea-30b1-1b1e76520f13
# ╠═7c2ec6c6-ee15-11ea-2d7d-0d9401a5e5d1
# ╟─649df270-ee24-11ea-397e-79c4355e38db
# ╟─9afc4dca-ee16-11ea-354f-1d827aaa61d2
# ╠═cf6b05e2-ee16-11ea-3317-8919565cb56e
# ╟─e3616062-ee27-11ea-04a9-b9ec60842a64
# ╟─e5b6cd34-ee27-11ea-0d60-bd4796540b18
# ╟─d06ea762-ee27-11ea-2e9c-1bcff86a3fe0
# ╟─e1dc0622-ee16-11ea-274a-3b6ec9e15ab5
# ╟─efd1ceb4-ee1c-11ea-350e-f7e3ea059024
# ╟─3cd535e4-ee26-11ea-2482-fb4ad43dda19
# ╟─7c41f0ca-ee15-11ea-05fb-d97a836659af
# ╠═8b96e0bc-ee15-11ea-11cd-cfecea7075a0
# ╠═edc6f6f6-dcba-4549-ba6e-11af4d70281b
# ╠═59265bd8-10fe-4584-ab80-c60f72391d0f
# ╟─0cabed84-ee1e-11ea-11c1-7d8a4b4ad1af
# ╟─5a5135c6-ee1e-11ea-05dc-eb0c683c2ce5
# ╠═577c6daa-ee1e-11ea-1275-b7abc7a27d73
# ╠═275a99c8-ee1e-11ea-0a76-93e3618c9588
# ╠═d3ad78a6-2d2d-4611-bd60-103363340a15
# ╠═42dfa206-ee1e-11ea-1fcd-21671042064c
# ╟─6e53c2e6-ee1e-11ea-21bd-c9c05381be07
# ╠═e7f8b41a-ee25-11ea-287a-e75d33fbd98b
# ╟─8a335044-ee19-11ea-0255-b9391246d231
# ╠═7c50ea80-ee15-11ea-328f-6b4e4ff20b7e
# ╠═0f507282-0492-4a6a-b3ec-9a4de5833352
# ╠═3f3b51ea-41c1-440b-a30a-52c1161aa6d5
# ╠═3aaaab5b-b124-4124-88d2-cbfc1f2ed6e6
# ╟─160ec6ff-a479-4362-b50b-526724e4243d
# ╠═aad67fd0-ee15-11ea-00d4-274ec3cda3a3
# ╠═9e4ddab6-e2ba-4ae1-8c84-3b251dff745f
# ╟─8ae59674-ee18-11ea-3815-f50713d0fa08
# ╠═94c0798e-ee18-11ea-3212-1533753eabb6
# ╠═a75701c4-ee18-11ea-2863-d3042e71a68b
# ╟─f461f5f2-ee18-11ea-3d03-95f57f9bf09e
# ╟─7c6642a6-ee15-11ea-0526-a1aac4286cdd
# ╠═af940d3e-a08e-4774-8d28-fb3c0aa5614a
# ╠═b8f86a7b-3cce-4c3e-adc1-131075d4791e
# ╠═8eeae29e-d8a8-4914-9a66-848707ad0187
# ╠═9eeb876c-ee15-11ea-1794-d3ea79f47b75
# ╠═1a0324de-ee19-11ea-1d4d-db37f4136ad3
# ╠═0aed3a2b-fb99-47f7-8f97-75c6ac0600e2
# ╠═22781bf6-f2cd-477f-9580-95508bebfa5c
# ╠═ca72e862-587c-4d54-9437-3b3cc2d5ecb1
# ╠═1bf94c00-ee19-11ea-0e3c-e12bc68d8e28
# ╠═40dbf222-5824-4126-b821-118aab847202
# ╟─1ff6b5cc-ee19-11ea-2ca8-7f00c204f587
# ╟─0001f782-ee0e-11ea-1fb4-2b5ef3d241e2
# ╠═1b85ee76-ee10-11ea-36d7-978340ef61e6
# ╠═477d0a3c-ee10-11ea-11cf-07b0e0ce6818
# ╠═91f4778e-ee20-11ea-1b7e-2b0892bd3c0f
# ╟─8ffe16ce-ee20-11ea-18bd-15640f94b839
# ╟─5842895a-ee10-11ea-119d-81e4c4c8c53b
# ╟─5516c800-edee-11ea-12cf-3f8c082ef0ef
# ╟─57360a7a-edee-11ea-0c28-91463ece500d
# ╟─dcb8324c-edee-11ea-17ff-375ff5078f43
# ╟─58af703c-edee-11ea-2963-f52e78fc2412
# ╟─f3d00a9a-edf3-11ea-07b3-1db5c6d0b3cf
# ╟─5aa9dfb2-edee-11ea-3754-c368fb40637c
# ╟─74d44e22-edee-11ea-09a0-69aa0aba3281
# ╟─115ded8c-ee0a-11ea-3493-89487315feb7
# ╟─dfb7c6be-ee0d-11ea-194e-9758857f7b20
# ╟─e15ad330-ee0d-11ea-25b6-1b1b3f3d7888
