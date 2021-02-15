module CrystalStructures


using Makie

export Crystal, Lattice, createLattice, fillLattice!, cube, sphere, torus, cone, scatter

"""
	Crystal

	Contains all the info about the crystal geometry:
		- dimensions of each  edge of the polyhedron;
		- angle between the three edges in the leftmost corner;
		- positioning and type of atom wrt to the fractional coordinates.
"""
struct Crystal
    a::Float64
    b::Float64
    c::Float64
    alpha::Float64
    beta::Float64
    gamma::Float64
	positionAndTypeOfAtoms::Array{Array{Any,1},1}
end

"""
	Lattice

	Contains the position and type of each atom in the lattice.
"""
struct Lattice
	atomType::Array{String,1}
	x::Array{Float64,1}
	y::Array{Float64,1}
	z::Array{Float64,1}
end

"""
	Crystal(type, args...)

	People can choose from one of the seven presets for the structure of the crystal: triclinic, monoclinic, orthorhombic, tetragonal,
	rhombohedral, hexagonal, or cubic.
"""
function Crystal(type, args...)
	if type == "triclinic"
		a, b, c, alpha, beta, gamma, positionAndTypeOfAtoms = args
		Crystal(a, b, c, alpha, beta, gamma, positionAndTypeOfAtoms)
	elseif type == "monoclinic"
		a, b, c, beta, positionAndTypeOfAtoms = args
		Crystal(a, b, c, pi/2, beta, pi/2, positionAndTypeOfAtoms)
	elseif type == "orthorhombic"
		a, b, c, positionAndTypeOfAtoms = args
		Crystal(a, b, c, pi/2, pi/2, pi/2, positionAndTypeOfAtoms)
	elseif type == "tetragonal"
		a, c, positionAndTypeOfAtoms = args
		Crystal(a, a, c, pi/2, pi/2, pi/2, positionAndTypeOfAtoms)
	elseif type == "rhombohedral"
		a, alpha, positionAndTypeOfAtoms = args
		Crystal(a, a, a, alpha, alpha, alpha, positionAndTypeOfAtoms)
	elseif type == "hexagonal"
		a, c, gamma, positionAndTypeOfAtoms = args
		Crystal(a, a, c, pi/2, pi/2, gamma, positionAndTypeOfAtoms)
	elseif  type == "cubic"
		a, positionAndTypeOfAtoms = args
		Crystal(a, a, a, pi/2, pi/2, pi/2, positionAndTypeOfAtoms)
	end
end

"""
	fracToCartesian(u,v,w,crystal)

	Converts from the coordinates in the crystal lattice to the global Cartesian coordinate system.
"""
function fracToCartesian(u,v,w,crystal)
	x = crystal.a*u+crystal.b*cos(crystal.gamma)*v+crystal.c*cos(crystal.beta)*w
	y = crystal.b*sin(crystal.gamma)*v + crystal.c*(cos(crystal.alpha)-cos(crystal.beta)*cos(crystal.gamma))/sin(crystal.gamma)*w
	z = crystal.a*crystal.b*crystal.c*sqrt(1-cos(crystal.alpha)^2-cos(crystal.beta)^2-cos(crystal.gamma)^2+2*cos(crystal.alpha)*cos(crystal.beta)*cos(crystal.gamma))/crystal.a/crystal.b/sin(crystal.beta)*w
	return [x,y,z]
end

"""
	createLattice()	

	Creates and empty lattice.
"""
function createLattice()
	return Lattice(String[],Float64[],Float64[],Float64[])
end

"""
	fillLattice!(lattice, crystal, region; bounds)

	Fills the lattice with atoms according to the region function. Default is a 50x50x50 grid. 
	The type and x,y,z coord of each atom are stored.
"""
function fillLattice!(lattice, crystal, region; bounds=[-50,50,-50,50,-50,50])
	for i in bounds[1]:bounds[2], j in bounds[3]:bounds[4], k in bounds[5]:bounds[6]

		for atom in crystal.positionAndTypeOfAtoms
            
            cartesianCoord = fracToCartesian(i+atom[2],j+atom[3],k+atom[4],crystal)

			if region(cartesianCoord...)

				push!(lattice.atomType, atom[1])
				push!(lattice.x, cartesianCoord[1])
				push!(lattice.y, cartesianCoord[2])
				push!(lattice.z, cartesianCoord[3])

			end
            
		end

	end
end

convert_arguments(P::Type{<:Scatter}, lattice::Lattice) = convert_arguments(P, (lattice.x, lattice.y, lattice.z))

#some functions for basic geometry
function sphere(x, y, z; x0=1, y0=1, z0=1, R=1)
	if (x-x0)^2+(y-y0)^2+(z-z0)^2<=R^2
		return true
	else
		return false
	end
end

#work on this!
function parallelipiped(x, y, z; x0=0, y0=0, z0=0, a=1, b, c)
	if 2<3

	else
		
	end
end

function cube(x, y, z; x0=1, y0=1, z0=1, a=1)
	if abs(x-x0)<=a && abs(y-y0)<=a && abs(z-z0)<=a
		return true
	else
		return false
	end
end

function cone(x, y, z; x0=0,y0=0,z0=0, c=1)
	if (z-z0)<=-sqrt(x^2+y^2) && 0<=z
		return true
	else
		return false
	end
end

function torus(x, y, z; x0=1, y0=1, z0=1, r=1, R=2.5)
	if (sqrt((x-x0)^2+(y-y0)^2)-R)^2+(z-z0)^2<r^2
		return true
	else 
		return false
	end
end	

end # module
