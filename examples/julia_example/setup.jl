# setup script to run only once to get the dependencies

using Pkg
Pkg.activate(@__DIR__)
Pkg.update()
