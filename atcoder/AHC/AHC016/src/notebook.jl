### A Pluto.jl notebook ###
# v0.19.15

using Markdown
using InteractiveUtils

# ╔═╡ 82d586bb-c0f2-41a8-b724-d7013a8b33f9
function tprint(lst)
	coins = [1, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
	out = open("./comb.txt", "w")
	for cd in lst
		tmp = []
		for i in 1:11
			if cd[i] != 0
				push!(tmp, [coins[i], cd[i]])
			end
		end
		println(out, tmp)
	end
	close(out)
end

# ╔═╡ d20d3972-8eb9-4684-8ffe-a8a7289a0c6a


# ╔═╡ ad095a5e-0806-4b01-ace4-bbaef0fd0073
begin
	cnt = 0
	cnt_dict_list = []
	
for i1 in 0:100
	for i10 in 0:10
		for i20 in 0:5
			for i30 in 0:4
				for i40 in 0:2
					for i50 in 0:2
						for i60 in 0:1
							for i70 in 0:1
								for i80 in 0:1
									for i90 in 0:1
										for i100 in 0:1
											if i1 + 10i10 + 20i20 + 30i30 + 40i40 +  50i50 + 60i60 + 70i70 + 80i80 + 90i90 + 100i100 == 100
												cnt += 1
												push!(cnt_dict_list, [i1, i10, i20, i30, i40, i50, i60, i70, i80, i90, i100])
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end
end

# ╔═╡ 583949a9-0c1c-41c1-b5b7-5fd34f0093e4
tprint(cnt_dict_list)

# ╔═╡ 617f85e6-8b65-4dbf-a4ca-0485273759ab


# ╔═╡ 8c304574-3bd5-4afb-9aa0-41ada96366fb


# ╔═╡ bb77cbf0-e3c3-40c2-a3c5-63e4320dd92e


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.2"
manifest_format = "2.0"
project_hash = "da39a3ee5e6b4b0d3255bfef95601890afd80709"

[deps]
"""

# ╔═╡ Cell order:
# ╠═82d586bb-c0f2-41a8-b724-d7013a8b33f9
# ╠═d20d3972-8eb9-4684-8ffe-a8a7289a0c6a
# ╠═ad095a5e-0806-4b01-ace4-bbaef0fd0073
# ╠═583949a9-0c1c-41c1-b5b7-5fd34f0093e4
# ╠═617f85e6-8b65-4dbf-a4ca-0485273759ab
# ╠═8c304574-3bd5-4afb-9aa0-41ada96366fb
# ╠═bb77cbf0-e3c3-40c2-a3c5-63e4320dd92e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
