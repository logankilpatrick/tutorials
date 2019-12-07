using Yao

mutable struct EchoReg{B} <: AbstractRegister{B}
    nactive::Int
    nqubits::Int
end

Yao.nactive(reg::EchoReg) = reg.nactive
Yao.nqubits(reg::EchoReg) = reg.nqubits

function Yao.instruct!(::EchoReg{B}, args...) where {B, G}
    println("calls: instruct!(reg, $\$$(join(string.(args), ", ")))")
end

function Yao.focus!(reg::EchoReg{B}, locs) where {B}
    println("focus -> $\$$locs")
    reg.nactive = length(locs)
    return true
end

function Yao.relax!(reg::EchoReg{B}, locs; to_nactive=nqubits(reg)) where {B}
    reg.nactive = to_nactive
    println("relax -> $\$$locs/$\$$to_nactive")
    return true
end

function Yao.measure!(rng, ::ComputationalBasis, reg::EchoReg{B}, locs) where {B}
    println("measure -> $\$$locs")
    return true
end

reg |> put(3, 2=>X) |> control(3, 3, 2=>X) |> concentrate(3, put(1, 1=>X), 2:2) |> measure!

reg |> cache(X)

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

