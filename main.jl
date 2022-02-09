# Importing our modules
# ==================================================================================================
include("guess_result.jl")

# Global Parameters
# ==================================================================================================
WORD_LEN = 5

struct BagOfWords
    """Set of words. It represents all words that are valid at certain step of the game"""

    words ::Vector{String}
end
function main()
    result = get_result("audio", "adios")
    println(result)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
