# complog-sokoban
Author: Robert Belanec

AIS ID: belalnec6

Date: 18.12.2021

A prolog program that solves a Sokoban game represented as a planning problem.

## Input specification:
- input filename: specified in main predicate.

## System requirements
- \*nix OS
- [swi-prolog](https://www.swi-prolog.org)

## How to run
1. git clone https://github.com/Wicwik/complog-sokoban-prolog
2. cd complog-sokoban-prolog
3. prolog main.pl
4. main('map-filename.txt')

**Sample command:**  prolog main.pl -> main('map4.txt').

Not tested on OS Windows.

Input: map4.txt
```
#########
#S  C  X#
#########
```
Output: stdout
```
Current map:
#########
#S  C  X#
#########

S0 = [next(10,11),next(11,10),at(S,10),next(11,12),next(12,11),free(11),next(12,13),next(13,12),free(12),next(13,14),next(14,13),at(C,13),next(14,15),next(15,14),free(14),next(15,16),next(16,15),free(15),free(16),at(X,16),width(9)]
G = [at(C,16)]
Plan = [move(10,11),move(11,12),push(12,13,14),push(13,14,15),push(14,15,16)]
true ;
false.
```
