include("global_parameters.jl")

using DataFrames
using CSV

struct Word
    content::String
    frequency::Float64
end

struct BagOfWords
"""Set of words. It represents all words that are valid at certain step of the game"""

    words ::Vector{Word}
end

"""
Generates a Bag of Words using a downloaded dataset

If you want to use other dataset, change this function to parse your custom file or add a new
function that generates the desired Bag of Words
"""
function load_dataset() ::BagOfWords

    # Read CSV file containing the data and put it on a DataFrame for easy manipulation
    df = CSV.File(WORD_DATASET_PATH, delim = ",", header = 1) |> DataFrame

    # The list of words we are going to build
    words = Vector{Word}()

    # Iterate over our dataset
    for row in eachrow(df)
        curr_word = Word(row["palabra"], row[" frecuencia normalizada"])
        push!(words, curr_word)
    end

    return BagOfWords(words)
end
