# This module runs all unit tests from different modules

include("guess_result.jl")
include("bag_of_words.jl")
include("exploration.jl")

function main()
    unit_test_guess_result()
    unit_test_bag_of_words()
    unit_test_exploration()
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end

