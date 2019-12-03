# Matrix Multiplication

##### Developed by:
1. [Alejandra Tubilla Castellanos](https://github.com/alejandratub)
2. [Aarón Zajac Hadid](https://github.com/Aarzh)

---
## 1. Description

* The program recieves 2 matrices from a text file and calculates the multiplication of        both using different threads

## 2. Program requirements

- To use the program it is necessary to install [Racket](https://download.racket-lang.org/)
- You will need a text editor to create your text files with the matrices

## 3. Text file requirements

- The text file should be a ".txt" format.

- The first line of the file should be the number of rows the first matrix has first and the number of columns the matrix has second.

- After the first line, write the first matrix.

- After all the elements of the first matrix are placed leave an empty line and repeat the  same order as the first one.

**Note: Remember that the number columns of the first matrix should match the number of rows of the second matrix**

## 4. Matrix Multiplication theory

- To be able to multiply two matrices it is necessaty to check if it is possible, to do this you must compare the number of columns of the first matrix and the number of rows of the second matrix, if they match, then the matrices can be multiplied with each other.

![alt text](images/compare.png)
- 