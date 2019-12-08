using Yao
using LinearAlgebra
using PyCall

pip = pyimport("pip._internal.main")
pip.main(["install", "pyscf", "openfermion", "openfermionpyscf"])

of_hamil = pyimport("openfermion.hamiltonians")
of_trsfm = pyimport("openfermion.transforms")
of_pyscf = pyimport("openfermionpyscf")

diatomic_bond_length = 1.0
geometry = [("H", (0., 0., 0.)), ("H", (0., 0., diatomic_bond_length))]
basis = "sto-3g"
multiplicity = 1
charge = 0
description = string(diatomic_bond_length)

molecule = of_hamil.MolecularData(geometry, basis, multiplicity, charge, description)
molecule = of_pyscf.run_pyscf(molecule,run_scf=1,run_fci=1)

m_h = molecule.get_molecular_hamiltonian()
nbits = m_h.n_qubits

jw_h = of_trsfm.jordan_wigner(of_trsfm.get_fermion_operator(m_h))

function yao_hamiltonian(nbits, jw_h)
    gates = Dict("X"=>X, "Y"=>Y, "Z"=>Z)
    h = Add{nbits}()
    for (k, v) in jw_h.terms
        op = v*put(nbits, 1=>I2)
        for t in k
            site, opname = t
            op = op*put(nbits, site+1=>gates[opname])
        end
        push!(h, op)
    end
    h
end

yao_h = yao_hamiltonian(nbits, jw_h)

w, v = eigen(Matrix(yao_h))

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

