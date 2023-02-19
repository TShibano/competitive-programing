parse_list_int(str=redline()) = parse.(Int64, split(str))

struct Edge
    id::Int64
    dist::Int64
    u::Int64
    v::Int64
end


function read_file()
    # ファイル操作
    println(ARGS)
    f = open(ARGS[1], "r")
    inputs = readlines(f)
    close(f)
    #println(inputs)
    return inputs
end 

function parser(inputs)
    println(length(inputs))
    println(inputs[1])
    N, M, D, K = inputs[1]
    println(N, M, D, K)
end

function main()
    inputs = read_file()
    parser(inputs)
end


function input1()
    println(ARGS)
    f = open(ARGS[1], "r")
    N, M, D, K = parse_list_int(readline(f))
    graph = fill(Edge(0, -1, 0, 0), N, N)
    edge_list = Vector{Edge}(undef, M)
    for i in 1:M
        u, v, w = parse_list_int(readline(f))
        tmp_edge = Edge(i, w, u, v)
        graph[u, v] = tmp_edge
        graph[v, u] = tmp_edge
        edge_list[i] =  tmp_edge
    end
    for i in 1:N
        x, y = parse_list_int(readline(f))
    end
    close(f)

    println(N, M, D, K)
    return N, M, D, K, graph, edge_list
end

input1()
