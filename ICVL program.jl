using CrystalStructures

#crystal and regions

GaAsPosition = [
				["As",0.0,0.0,0.0],["As",1.0,0.0,0.0],["As",0.5,0.5,0.0],["As",0.0,1.0,0.0],["As",1.0,1.0,0.0],
				["Ga",0.25,0.25,0.25],["Ga",0.75,0.75,0.25],
				["As",0.5,0.0,0.5],["As",0.5,1.0,0.5],["As",0.0,0.5,0.5],["As",1.0,0.5,0.5],
				["Ga",0.25,0.75,0.75],["Ga",0.75,0.25,0.75],
				["As",0.0,0.0,1.0],["As",1.0,0.0,1.0],["As",0.0,1.0,1.0],["As",1.0,1.0,1.0]
]

crystalGaAs = Crystal("cubic", 0.2, GaAsPosition)

function wettingLayer(x, y, z)
    if -3<=x<=3 && -3<=y<=3 && 0<=z<=0.25
        return true
    else 
        return false
    end
end

coneQD(x, y, z) = cone(x, y, z, x0=0.0, y0=0.0, z0=2, c=1) && z>=0

GaSbPosition = [
				["Sb",0.0,0.0,0.0],["Sb",1.0,0.0,0.0],["Sb",0.5,0.5,0.0],["Sb",0.0,1.0,0.0],["Sb",1.0,1.0,0.0],
				["Ga1",0.25,0.25,0.25],["Ga1",0.75,0.75,0.25],
				["Sb",0.5,0.0,0.5],["Sb",0.5,1.0,0.5],["Sb",0.0,0.5,0.5],["Sb",1.0,0.5,0.5],
				["Ga1",0.25,0.75,0.75],["Ga1",0.75,0.25,0.75],
				["Sb",0.0,0.0,1.0],["Sb",1.0,0.0,1.0],["Sb",0.0,1.0,1.0],["Sb",1.0,1.0,1.0]
]

crystalGaSb = Crystal("cubic", 0.3, GaSbPosition)

fillMaterial(x, y, z) = !wettingLayer(x, y, z) && !coneQD(x, y, z) && -3<=x<=3 && -3<=y<=3 && 0<=z<=2.5

#3D part

lattice = createLattice()

fillLattice!(lattice, crystalGaAs, wettingLayer)

fillLattice!(lattice, crystalGaAs, coneQD)

fillLattice!(lattice, crystalGaSb, fillMaterial)

colorDict = Dict(["Ga"=>1, "Ga1"=> 2, "As"=>3, "Sb"=>4])

colors = [colorDict[el] for el in lattice.atomType]

scene = scatter(lattice.x, lattice.y, lattice.z, color=colors, markersize=6)

#slice part

wettingLayerSlice(x, y, z) = wettingLayer(x, y, z) && -0.25<=x<=0.25

coneQDSlice(x, y, z) = coneQD(x, y, z) && -0.25<=x<=0.25

fillMaterialSlice(x, y, z) = fillMaterial(x, y, z) && -0.25<=x<=0.25

lattice = createLattice()

fillLattice!(lattice, crystalGaAs, wettingLayerSlice)

fillLattice!(lattice, crystalGaAs, coneQDSlice)

fillLattice!(lattice, crystalGaSb, fillMaterialSlice)

colorDict = Dict(["Ga"=>1, "Ga1"=> 2, "As"=>3, "Sb"=>4])

colors = [colorDict[el] for el in lattice.atomType]

scene = scatter(lattice.y, lattice.z, color=colors, markersize=6)