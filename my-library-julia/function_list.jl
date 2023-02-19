# function list

N::Int = 100

# input ====
parseListInt(str=readline()) = parse.(Int, split(str))
parseInt(str=readline()) = parse(Int, str)


# permutation, combination
factorial(N)        # N!
binomial(N, k)      # NCk
binomial(N, k) * factorial(k)   # NPk


"""target が array(sort済み) に含まれるか"""
function binary_search(array::Vector{Int}, target::Int)::Bool
    lower = 1
    upper = length(array)
    while lower <= upper
        mid = Int(round((lower + upper)/2))
        if array[mid] < target
            lower = mid + 1
        elseif array[mid] > target
            upper = mid - 1
        end
        if array[mid] == target
            return true
        end
    end
    return false
end

