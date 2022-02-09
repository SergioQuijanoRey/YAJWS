module GuessResultMod
export ResultType, GuessResult

using Test

"""Result of a certain guess on a certain position of the word"""
@enum ResultType Good Bad BadPosition

struct GuessResult
    """Result of a certain guess"""

    result :: Vector{ResultType}
end

function get_result(target_word::String, guessed_word::String) ::GuessResult
    """Given the target word, and a guess, returns the result of that guess"""

    # Sanity check
    if length(target_word) != length(guessed_word)
        throw(DimensionMismatch("Target word and guessed word must have same len"))
    end

    # The result we are going to build
    result_positions = Vector{ResultType}()

    # Available letters to check for BadPosition
    #
    # If Good or BadPosition is matched to this letter, then this letter should not be considered
    # again for BadPosition
    available_letters = [target_word[i] for i in 1:length(target_word)]

    for i in 1:length(target_word)

        # This is the correct position
        if target_word[i] == guessed_word[i]
            # Add the type of result
            push!(result_positions, Good)

            # Consume this letter
            deleteat!(available_letters, findall(x->x==guessed_word[i],available_letters)[1])

            continue
        end

        # This is not the correct position but this letter is in the word
        if guessed_word[i] ∈ available_letters
            # Add the type of result
            push!(result_positions, BadPosition)

            # Consume this letter
            deleteat!(available_letters, findall(x->x==guessed_word[i],available_letters)[1])

            continue
        end

        # This letter is not in the word
        push!(result_positions, Bad)
    end

    return GuessResult(result_positions)
end

# Overload == operator to run some tests
import Base.==
function isequal(first::GuessResult, second::GuessResult)

    # Sanity check
    if length(first.result) != length(second.result)
        return false
    end

    for i in 1:length(first.result)
        if first.result[i] !== second.result[i]
            return false
        end
    end

    return true
end
function ==(first::GuessResult, second::GuessResult)
    return isequal(first, second)
end

function run_test_suite()
    """Run all unit tests on this struct"""

    println("==> RUNNING TESTS ON STRUCT GuessResult")

    # Basic checks
    @test get_result("audio", "audil") == GuessResult([Good, Good, Good, Good, Bad])
    @test get_result("audio", "audio") == GuessResult([Good, Good, Good, Good, Good])
    @test get_result("audio", "axdxo") == GuessResult([Good, Bad, Good, Bad, Good])
    @test get_result("barco", "audio") == GuessResult([BadPosition, Bad, Bad, Bad, Good])

    # Letter that is in the word, but other word has ocuppied it (ie. it has associated good position)
    # should not appear as BadPosition
    @test get_result("audio", "audia") == GuessResult([Good, Good, Good, Good, Bad])
    @test get_result("audio", "audii") == GuessResult([Good, Good, Good, Good, Bad])
    @test get_result("audio", "audiu") == GuessResult([Good, Good, Good, Good, Bad])

    # Check that words with different lengths throw expected error
    @test_throws DimensionMismatch get_result("aaaaa", "aaaa")
    @test_throws DimensionMismatch get_result("aaaa", "aaaaaa")

    println("==> END RUNNING TESTS ON STRUCT GuessResult")
    println("")

end

end
