using .QuestDB
using .LibQuestDB
using c_questdb_client_jll
using Test




# test QuestDB.jl functions
@testset "New buffer" begin    
    sender = Sender("localhost", "9009")    
    @test length(sender.buffer) == 1
    @test capacity(sender) == 64 * 1024
end




