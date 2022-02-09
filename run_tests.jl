# This module runs all unit tests from different modules

include("guess_result.jl")

function main()
    # Running tests on struct GuessResult
    run_test_suite()
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end

