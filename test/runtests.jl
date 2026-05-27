using QuestDB
using Dates
using Test
include("mock_server.jl")

# test QuestDB.jl functions
@testset "Sender testing" begin    
    server = py"Server"()        
    sender = Sender("localhost", server.port)
    server.accept()
    
    # Row 1
    sender.table("tab1")
    sender.symbol("t1", "val1")
    sender.symbol("t2", "val2")    
    sender.column("f1", true)
    sender.column("f2", 12345)
    sender.column("f3", 10.75)
    sender.column("f4", "val3")    
    sender.at(Dates.Nanosecond(1423299927000000000))  
    
    # Row 2
    sender.table("tab1")
    sender.symbol("tag3", "value 3")
    sender.symbol("tag4", "value:4")    
    sender.column("field5", false)
    sender.at(Dates.Nanosecond(1423299927000000000))

    sender.flush()
    msgs = server.recv()
    println(msgs)
    @test capacity(sender) == 64 * 1024    
    @test msgs == ["tab1,t1=val1,t2=val2 f1=t,f2=12345i,f3=10.75,f4=\"val3\" 1423299927000000000", "tab1,tag3=value\\ 3,tag4=value:4 field5=f 1423299927000000000"]    
    
end
