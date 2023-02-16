using .QuestDB
using BenchmarkTools
using Dates

auth = (
    "testUser1",                                    # kid
    "5UjEMuA0Pj5pjK8a-fa24dyIf-Es5mYny3oE_Wmus48",  # d
    "fLKYEaoEb9lrn3nkwLDA-M_xnuFOdSt9y0Z7_vWSHLU",  # x
    "Dt5tbS1dEDMSYfym3fgMv0B99szno-dFc1rYF9t0aac"   # y
)  

sender = Sender("localhost", 9009, auth)

#TODO: check it out how to do the auto_flushing
#TODO: How to close the sender 
@time try                  
    for i in 1:300_000
        sender.table("testing_OOP2")
        sender.symbol("first_symbol", "first_symbol")
        sender.column("column_a", "value_a")
        sender.column("column_b_int", 1)
        sender.column("column_c_float", 1.1)
        sender.column("column_d_bool", true)
        sender.column("timestamp_column", Dates.Microsecond(1674983677000000))
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

