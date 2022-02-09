# Yet Another Julia Wordle Solver

- Simple *Julia* program that plays the game of *Wordle*

## Used Data

- This program expects a CSV file with the list of words,a measure of the absolute frequency of that word, and a measure of the relative frequency of the word
- Thus, you can change the dataset used by the solver
- The dataset I used:
    - From the *Real Academia Española de la Lengua*, *CREA* databank
    - Click [here](https://corpus.rae.es/frec/CREA_total.zip) for downloading used dataset
    - I formatted this dataset to have a CSV file containing `word, abs freq, relative freq` (using VIM Macros)
