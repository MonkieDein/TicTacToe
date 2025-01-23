# Tic Tac Toe
# 2 players
# Taking round
# Iterate over all possibilities
# 3 x 3 boards
# ----------------
# |    |    |    |
# |--------------|    
# |    |    |    |
# |--------------|    
# |    |    |    |
# |--------------|   
include("utils.jl") 
using Combinatorics

# Defining all wining condition
win_cond = vcat([[i==k for i in 1:3, j in 1:3] for k in 1:3],[[j==k for i in 1:3, j in 1:3] for k in 1:3],[[i==j for i in 1:3, j in 1:3]],[[i==4-j for i in 1:3, j in 1:3]])
win_cond = [vcat(win...) for win in win_cond]

# Define all possible games
games = collect(permutations(1:9, 9))
winner = [points_to(game,win_cond) for game in games]

# Offensive score : If we played optimally, how many possible ways opponent can make mistake and lose
q = Dict()
board = (0,0,0,0,0,0,0,0,0)
for play in 1:9
    cur_v = play_game(q,choose(board,1,play),-1,win_cond,f1=maximum,f2=sum,p1w=1,p2w=-10000)
end
[q[choose(board,1,i)] for i in 1:9]


# Defensive score : If we can only play the first move, opponent play optimally
# How many possible ways we could lose.
q = Dict()
board = (0,0,0,0,0,0,0,0,0)
for play in 1:9
    cur_v = play_game(q,choose(board,1,play),-1,win_cond,f1=sum,f2=minimum,p1w=10000,p2w=-1)
end
reshape([q[choose(board,1,i)] for i in 1:9],(3,3))
[ (i==1 ? 0 : q[sequence_play([1,i])]) for i in 1:9]
[ (i==2 ? 0 : q[sequence_play([2,i])]) for i in 1:9]
[ (i==5 ? 0 : q[sequence_play([5,i])]) for i in 1:9]


# If both player play optimally: Then will always end with ties.
q = Dict()
board = (0,0,0,0,0,0,0,0,0)
for play in 1:9
    cur_v = play_game(q,choose(board,1,play),-1,win_cond,f1=maximum,f2=minimum)
end
[q[choose(board,1,i)] for i in 1:9]

[ (i in [1,2] ? 0 : q[sequence_play([1,2,i])]) for i in 1:9]

