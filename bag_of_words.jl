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
    curr_it = 0
    for row in eachrow(df)
        curr_word = Word(row["palabra"], row[" frecuencia normalizada"])
        push!(words, curr_word)

        # TODO -- delete this. I used this to speed up computations
        curr_it += 1
        if curr_it == 20
            break
        end
    end

    return BagOfWords(words)
end

"""
Normalizes the frequencies of the words in the bag, to represent a probability distribution (that's
to say, sum of probs add up to 1)
"""
function normalize_frequencies(bag::BagOfWords) ::BagOfWords
    total_words = big(0)

    # Compute the total sum of frequencies
    for word in bag.words
        total_words += word.frequency
    end

    # Create new bag of words using normalized frecuencies
    # Normalize using prev computed value
    new_words = Vector{Word}()
    for word in bag.words
        new_word = Word(word.content, word.frequency / total_words)
        push!(new_words, new_word)
    end

    return BagOfWords(new_words)
end

function length(bag::BagOfWords)
    return length(bag.words)
end
