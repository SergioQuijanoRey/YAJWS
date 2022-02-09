# This module runs all unit tests from different modules

include("guess_result.jl")
include("bag_of_words.jl")

function main()
    GuessResultMod.run_test_suite()
    BagOfWordsMod.run_test_suite()
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end

