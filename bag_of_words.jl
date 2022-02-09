module BagOfWordsMod
export Word, BagOfWords

include("global_parameters.jl")

using DataFrames
using CSV
using Test

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

"""
Normalizes the frequencies of the words in the bag, to represent a probability distribution (that's
to say, sum of probs add up to 1)
"""
function normalize_frequencies(bag::BagOfWords) ::BagOfWords

    # Compute the total sum of all frequencies
    freq_sum = get_sum_of_frequencies(bag)

    # Create new bag of words using normalized frecuencies
    # Normalize using prev computed value
    new_words = Vector{Word}()
    for word in bag.words
        new_word = Word(word.content, word.frequency / freq_sum)
        push!(new_words, new_word)
    end

    return BagOfWords(new_words)
end

"""Computes the sum of all the frequencies in the bag"""
function get_sum_of_frequencies(bag::BagOfWords) ::Float64
    frequencies = [word.frequency for word in bag.words]
    return sum(frequencies)
end

# Overload some operators to make working with the struct more easy
# ==================================================================================================

import Base.length
function length(bag::BagOfWords)
    return length(bag.words)
end

# Unit testing
# ==================================================================================================

function run_test_suite()
    """Run all unit tests on this struct"""

    println("==> RUNNING TESTS ON STRUCT GuessResult")

    normalized_frequencies_sum_up_one()

    println("==> END RUNNING TESTS ON STRUCT GuessResult")
    println("")
end

function normalized_frequencies_sum_up_one()
    bag = load_dataset()
    norm_bag = normalize_frequencies(bag)
    @test get_sum_of_frequencies(norm_bag) ≈ 1.0 atol = 0.001
end

if abspath(PROGRAM_FILE) == @__FILE__
    run_test_suite()
end

end
