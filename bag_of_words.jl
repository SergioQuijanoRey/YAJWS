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
function load_raw_dataset() ::BagOfWords

    # Read CSV file containing the data and put it on a DataFrame for easy manipulation
    df = CSV.File(WORD_DATASET_PATH, delim = ",", header = 1) |> DataFrame

    # The list of words we are going to build
    words = Vector{Word}()

    # Iterate over our dataset
    for row in eachrow(df)
        # Get the data from the file
        content = row["palabra"]
        frequency = row[" frecuencia normalizada"]

        # Sanitize the content of the word
        content = strip(content)

        # Add the word
        curr_word = Word(content, frequency)
        push!(words, curr_word)
    end

    return BagOfWords(words)
end

"""Generates a processed Bag of Words"""
function load_clean_dataset() ::BagOfWords

    # Start from the raw BagOfWords
    bag = load_raw_dataset()

    # Only consider words with appropriate length
    filtered_bag = only_words_with_given_length(bag)

    # Normalize the frequencies of the bag
    normalized_filtered_bag = normalize_frequencies(filtered_bag)

    # Choose only words with frequencies over certain threshold
    common_words_bag = only_words_above_given_freq_threshold(normalized_filtered_bag)

    # Normalize again and return
    return normalize_frequencies(common_words_bag)
end

"""
Removes all the words that haven't got the game length
This length is specified in the global parameters
"""
function only_words_with_given_length(bag::BagOfWords) ::BagOfWords
    new_words = filter(word -> length(word.content) == WORD_LEN, bag.words)
    return BagOfWords(new_words)
end

"""
Removes all the words whose frequency is below some threshold
This threshold is specified in the global parameters
"""
function only_words_above_given_freq_threshold(bag::BagOfWords) ::BagOfWords
    new_words = filter(word -> word.frequency >= FREQUENCY_THRESHOLD, bag.words)
    return BagOfWords(new_words)
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

"""Computes the entropy of the bag of words"""
function entropy(bag::BagOfWords) ::Float64

    # Get all the frequencies
    frequencies = get_frequencies(bag)

    # Compute the expression of the summands
    f = prob -> big(prob) * log2(big(prob))
    summands = f.(frequencies)

    # Remove NaN values
    # NaN values are associeated to freqs very close to 0 that are not that valuable
    summands = filter(x -> isnan(x) == false, summands)

    # Return the sum of the summands
    return -sum(summands)
end

# Aux methods
# ==================================================================================================

"""Gets the list with all the frequencies of the words"""
function get_frequencies(bag::BagOfWords) ::Vector{Float64}
    return [word.frequency for word in bag.words]
end

"""Computes the sum of all the frequencies in the bag"""
function get_sum_of_frequencies(bag::BagOfWords) ::Float64
    return sum(get_frequencies(bag))
end


# Overload some operators to make working with the struct more easy
# ==================================================================================================

import Base.length
function length(bag::BagOfWords)
    return length(bag.words)
end

# Unit testing
# ==================================================================================================
using Test

function unit_test_bag_of_words()
    """Run all unit tests on this struct"""

    println("==> RUNNING TESTS ON STRUCT GuessResult")

    normalized_frequencies_sum_up_one()

    println("==> END RUNNING TESTS ON STRUCT GuessResult")
    println("")
end

function normalized_frequencies_sum_up_one()
    bag = load_clean_dataset()
    @test get_sum_of_frequencies(bag) ??? 1.0 atol = 0.001
end

