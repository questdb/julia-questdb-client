using .QuestDB
using BenchmarkTools
using Dates

sender = Sender("localhost", 9009)

#TODO: check it out how to do the auto_flushing
#TODO: How to close the sender 
@time try                  
    for i in 1:100
        sender.table("testing_OOP11")
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

