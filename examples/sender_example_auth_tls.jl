using .QuestDB
using BenchmarkTools
using Dates

auth = (
    "testUser1",                                    # kid
    "5UjEMuA0Pj5pjK8a-fa24dyIf-Es5mYny3oE_Wmus48",  # d
    "fLKYEaoEb9lrn3nkwLDA-M_xnuFOdSt9y0Z7_vWSHLU",  # x
    "Dt5tbS1dEDMSYfym3fgMv0B99szno-dFc1rYF9t0aac"   # y
)  

sender = Sender("ilp.360.ienai.space", 9009, auth=auth, tls=true, init_capacity=128*1024)
#convert this to microseconds

a = 9.466847946445221e8 * 1_000_000

@time try                  
    for i in 1:10_000_000
        sender.table("tst3")
        sender.symbol("first_symbol", "first_symbol")
        sender.column("column_a", "value_a")
        sender.column("column_b_int", 1)
        sender.column("column_c_float", 1.1)
        sender.column("column_d_bool", true) 
        sender.column("timestamp_column", Dates.Microsecond(round(a)))
        #TODO: implement datetime.datetime.utcnow()
        #sender.at_now()        
        sender.at(Dates.Nanosecond(1423299927000000000))        
    end    
    sender.flush()
catch e
    println(e)
finally
    sender.close()
end
