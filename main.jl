# Importing our modules
# ==================================================================================================
include("guess_result.jl")
include("bag_of_words.jl")

# Global Parameters
# ==================================================================================================
function main()
    result = GuessResultMod.get_result("audio", "adios")
    println(result)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
