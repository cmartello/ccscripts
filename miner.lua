-- BranchMine
-- ComputerCraft  mining turtle script

-- a couple global dictionaries to save space later

detect = { U = turtle.detectUp, F = turtle.detect,  D = turtle.detectDown }
move =   { U = turtle.up,       F = turtle.forward, D = turtle.down,       B = turtle.back }
dig =    { U = turtle.digUp,    F = turtle.dig,     D = turtle.digDown }

function main()
    showusage()
    vertshaft()
    bigtunnel(12)
end

function showusage()
    -- title page and instructions for the user
    print("BranchMiner 0.1")
    print("Automatically creates the beginnings of a multi-layered branch mine.")
    print("Load the following items into the bottom row in this order:")
    print("chests, ladders, torches, fuel (such as coal).")
end

function failsafe_move(mdir)
    -- accepts a single letter ("U", "D", "F", "B") and moves in that direction.
    -- if there's sand/gravel in the way, this will clear it first
    -- if the turtle is out of fuel, it will consume fuel from slot 16 first.

    -- first, make sure that there's fuel to operate
    if turtle.getFuelLevel() == 0 then
        turtle.select(16)
        rf = turtle.refuel(1)
        if rf == false then
            print("FATAL: Out of fuel.")
            -- end program here?
        elseif rf == true then
            print("Turtle refueled to " .. turtle.getFuelLevel() .. " moves.")
        end
    end

    -- detect, dig (if needed), then move
    while detect[mdir]() == true do
        dig[mdir]()
    end

    move[mdir]()
end

function vertshaft()
    -- get the current elevation from the user (assume that there is no GPS)
    print("Current elevation : ")
    cur_elevation = tonumber(io.read())
    print("Desired elevation (13 suggested): ")
    des_elevation = tonumber(io.read())

    -- main loop -- digs, moves, places ladders
    for x = cur_elevation, des_elevation, -1 do
        -- dig 
        failsafe_move("D")
        -- select ladders
        turtle.select(14)
        -- place ladder above
        turtle.placeUp()
    end
end

function break3()
    -- support function for bigtunnel
    failsafe_move("F")
    turtle.digUp()
    turtle.digDown()
end


function bigtunnel(len)
    -- Creates a 3x3 tunnel in front of the turle with length specified in 'len'
    -- does not fill in floors/ceilings (yet)

    -- elevate a little bit first
    failsafe_move("U")

    -- mongo smash
    for i = 1, len do
        break3()
    end

    -- do a left-handed U-Turn
    turtle.turnLeft()
    break3()
    turtle.turnLeft()

    -- mongo smash
    for i = 1, len-1 do
        break3()
    end

    -- turn and move to the right-hand side
    turtle.turnLeft()
    failsafe_move("F")
    failsafe_move("F")
    turtle.turnLeft()
    turtle.digUp()
    turtle.digDown()

    -- mongo smash
    for i = 1, len-1 do
        break3()
        if i % 4 == 0 then
            -- mongo like torches
            turtle.turnRight()
            turtle.back()
            turtle.select(15)
            turtle.forward()
            turtle.turnLeft()
        end
    end
end

function branchtunnel(len)
    -- creates a 2x2 tunnel with 1x2 alcoves every 4 meters for layered branch mining
    
end

function checkinventory()
    -- checks to see if slot #12 contains any items.
    -- if it does, create a chest and unload into it.
    -- This is not an ideal solution, but it works better than nothing.
end

main()
