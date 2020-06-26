# normal
solver = MCTSSolver(n_iterations=n_iter, depth=depth, exploration_constant=ec, enable_tree_vis=true)
mdp = LegacyGridWorld()

policy = solve(solver, mdp)

state = GridWorldState(1,1)

a = action(policy, state)

tree = D3Tree(policy, state)

io = IOBuffer()
show(io, MIME("text/plain"), tree)
take!(io)
show(io, MIME("text/html"), tree)

# dpw
solver = DPWSolver(n_iterations=n_iter, depth=depth, exploration_constant=ec, rng=MersenneTwister(13), tree_in_info=true)
mdp = LegacyGridWorld()

policy = solve(solver, mdp)

state = GridWorldState(1,1)

a, info = action_info(policy, state)

tree = D3Tree(policy)
tree = D3Tree(info[:tree])

io = IOBuffer()
show(io, MIME("text/plain"), tree)
take!(io)
show(io, MIME("text/html"), tree)
