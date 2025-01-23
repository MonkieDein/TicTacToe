function checkForWinner(board,win_cond;p1reward = 1,p2reward = -1)
    cond_sum = [sum(board .* cond) for cond in win_cond]
    if maximum(cond_sum) == 3
        return p1reward
    end
    if minimum(cond_sum) == -3
        return p2reward
    end
    return 0
end

function points_to(game,win_cond;p1reward = 1,p2reward = -1)
    player = 1
    board = [0 for i in 1:9]
    for loc in game
        board[loc] = player
        winner = checkForWinner(board,win_cond,p1reward=p1reward,p2reward=p2reward)
        if winner != 0
            return winner
        end
        player *= -1
    end
    return 0
end

function choose(board,player,location)
    return tuple([ifelse(i==location,player,c) for (i,c) in enumerate(board)]...)
end

function play_game(q,board,player,win_cond;f1=maximum,f2=sum,p1w = 1,p2w = -1)
    # println(board)
    if haskey(q,board) 
        return q[board]
    end
    has_winner = checkForWinner(board,win_cond,p1reward = p1w,p2reward = p2w)
    if has_winner != 0
        q[board] = has_winner * factorial(sum(board .== 0))
    else
        valid = findall(board .== 0)
        if length(valid) == 0
            q[board] = 0
            return q[board]
        end
        if player == 1
            q[board] = f1([play_game(q,choose(board,player,play),-player,win_cond,f1=f1,f2=f2,p1w=p1w,p2w=p2w) for play in valid])
        elseif player == -1
            q[board] = f2([play_game(q,choose(board,player,play),-player,win_cond,f1=f1,f2=f2,p1w=p1w,p2w=p2w) for play in valid])
        end
    end
    return q[board]
end

function showInBoard(vec9elems)
    return reshape(collect(vec9elems),(3,3))
end

function displayboard(board)
    return showInBoard([ifelse(b==0," ", ifelse(b==1,"X","O")) for b in collect(board)])
end

function sequence_play(sequence)
    temp = zeros(Int,9)
    player = 1
    for s in sequence
        temp[s] = player
        player *= -1
    end
    return tuple(temp...)
end

