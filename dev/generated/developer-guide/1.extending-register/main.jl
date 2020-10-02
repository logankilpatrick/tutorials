using Yao

mutable struct EchoReg{B} <: AbstractRegister{B}
    nactive::Int
    nqubits::Int
end

Yao.nactive(reg::EchoReg) = reg.nactive
Yao.nqubits(reg::EchoReg) = reg.nqubits

function Yao.instruct!(::EchoReg{B}, args...) where {B, G}
    str = join(string.(args), ", ")
    println("calls: instruct!(reg, $str)")
end

function Yao.focus!(reg::EchoReg{B}, locs) where {B}
    println("focus -> $locs")
    reg.nactive = length(locs)
    return true
end

function Yao.relax!(reg::EchoReg{B}, locs; to_nactive=nqubits(reg)) where {B}
    reg.nactive = to_nactive
    println("relax -> $locs\\$to_nactive")
    return true
end

function Yao.measure!(::NoPostProcess, ::ComputationalBasis, reg::EchoReg{B}, locs) where {B}
    println("measure -> $locs")
    return true
end

r = EchoReg{10}(3, 2)
r |> put(3, 2=>X) |> control(3, 3, 2=>X) |> concentrate(3, put(1, 1=>X), 2:2) |> measure!

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

