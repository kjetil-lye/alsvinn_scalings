def init_global(rho, ux, uy, uz, p, nx, ny, nz):
	N = len(a)/6
	a1 = a[:N]
	a2 = a[N:2*N]
	a3 = a[2*N:3*N]
	b1 = a[3*N:4*N]
	b2 = a[4*N:5*N]
	b3 = a[5*N:6*N]

	perturbation = 0.1
	normalization1 = sum(a1)
	if abs(normalization1) < 1e-10:
		normalization1 = 1
	normalization2 = sum(a2)
	if abs(normalization2) < 1e-10:
		normalization2 = 1

	x = linspace(0, 1, nx)
	y = linspace(0,1, ny)
	z = linspace(0,1, nz)
	X, Y, Z = meshgrid(x, y, z)
	X = X
	Y = Y
	Z = Z

	R = sqrt((Y - 0.5)**2 + (Z - 0.5)**2)

	Theta = arctan2(Z, Y)
	perturbation_radius = perturbation*sum([a1[i]*cos(2*pi*(i+1)*(R+b1[i])) for i in range(len(a1))], 0)/normalization1
	perturbation_radius += perturbation*sum([a2[i]*cos(2*pi*(i+1)*(Theta+b2[i])) for i in range(len(a2))], 0)/normalization2
	perturbation_radius += perturbation*sum([a3[i]*cos(2*pi*(i+1)*(X+b3[i])) for i in range(len(a3))], 0)/normalization2
	perturbation_radius /= 2

	middle = (R < 0.25 + perturbation_radius)

	rho[:, :, :] = 2.0 * middle + 1.0*(1-middle)
	uy[:, :, :] = -0.5*middle + 0.5*(1-middle)
	ux[:,:,:] = zeros_like(X)
	uz[:,:,:] = zeros_like(X)
	p[:,:,:] = 2.5*ones_like(X)


#

#
#
# perturbation = 0.01
# normalization1 = sum(a1)
# if abs(normalization1) < 1e-10:
# 	normalization1 = 1
# normalization2 = sum(a2)
# if abs(normalization2) < 1e-10:
# 	normalization2 = 1
#
# perturbation_upper = perturbation*sum([a1[i]*cos(2*pi*(i+1)*(x+b1[i])) for i in range(len(a1))])/normalization1
# perturbation_lower = perturbation*sum([a2[i]*cos(2*pi*(i+1)*(x+b2[i])) for i in range(len(a2))])/normalization2
#
# if y < 0.25 + perturbation_lower or y > 0.75 + perturbation_upper:
#     rho = 1
#     ux = 0.5
#     uy = 0
#     p = 2.5
# else:
#     rho = 2
#     ux = -0.5
#     uy = 0
#     p = 2.5
