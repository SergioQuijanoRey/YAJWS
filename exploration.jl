"""Module dedicated to explore and choose all the possible words to make a guess"""

include("guess_result.jl")
include("bag_of_words.jl")

"""Takes a bag and a guess, and returns the words of that bag that are valid according to the result"""
function filter_bag_using_result(bag::BagOfWords, result::GuessResult, guessed_word::String) :: BagOfWords
    filtered_bag = bag
    for i in 1:length(guessed_word)
        if result.result[i] === Good
            filtered_bag = bag_must_have_letter(filtered_bag, guessed_word[i], i)
        end
    end
end

function bag_must_have_letter(bag::BagOfWords, letter::Char, position::Int64)::BagOfWords
    new_words = Vector{Word}()

    for word in bag.words
        if word.content[position] == letter
            push!(new_words, word)
        end
    end

    return BagOfWords(new_words)
end

# Unit testing
# ===================================================================================================
function unit_test_exploration()
    println("==> RUNNING TESTS ON STRUCT GuessResult")

    println("==> END RUNNING TESTS ON STRUCT GuessResult")
    println("")
end
