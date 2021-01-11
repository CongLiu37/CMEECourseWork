Project: Week2
Description: CMEE Course work of week 1
Languages: Python 3
Dependencies: Python modules including csv, sys, pickle
Auther: Cong Liu (cong.liu20@imperial.ac.uk)

Individual Work

(1) align_seqs.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week2/Code
Input: Two sequences saved in Data/align.fasta
Function: Align two sequences saved in input file
Output: The best alignment and corresponding score, saved in Results/align.txt
Usage: python align_seqs.py
Date: Oct, 2020

(2) basic_csv.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week2/Code
Dependencies: csv
Input: testcsv.csv saved in CMEECourseWork/Week2/Data
Output: Print rows and corresponded species name in terminal
        Save species name and body mass in Results/bodymass.csv
Usage: python basic_csv.py
Date: Oct, 2020

(3) basic_io1.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week2/Code
Input file: Sandbox/test.txt
Function: Print all lines of input file
          Print all lines that contains letters in input file
Usage: python basic_io1.py
Date: Oct, 2020

(4) basic_io2.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week2/Code 
Function: Write 0-99 in output file
          One number in each line.
Output: Sandbox/testout.txt
Usage: python basic_io2.py
Date: Oct, 2020

(5) basic_io3.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week2/Code
Dependencies: pickle
Input file:
Function: Save a dictionary in Sandbox/testp.p as binary file
          Read the binary file
          Print the dictionary
Output: Sandbox/testp.p
Usage: python basic_io3.py
Date: Oct, 2020

(6) boilerplate.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week2/Code
Dependencies: sys
Function: Exemplify the usage of main function
Usage: python boilerplate.py
Date: Oct, 2020

(7) cfexercises1.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week2/Code
Dependencies: sys
Description: Some functions for numberic calculation
Usage: python cfexercises1.py
Date: Oct, 2020

(8) cfexercise2.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Cong Liu: CMEECourseWork/Week2/Code
Description: Show the usage of for and while loop
Usage: python cfexercise2.py
Date: Oct, 2020

(9) control_flow.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week2/Code
Dependencies: sys
Function: Exemplify the use of control statements by some functions
Usage: python control_flow.py
Date: Oct, 2020

(10) debugme.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week2
Function: Exemplify the process of debugging
Date: Oct, 2020

(11) dictionary.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Script: dictionary.py
Work Path: CMEECourseWork/Week2/Code
Function: Populate a dictionary called taxa_dic derived from  taxa so that it maps order names to sets of taxa.
Usage: python dictionary.py
Date: Oct, 2020

(12) lc1.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week2/Code
Function: create three different lists containing the latin names, common names and mean body masses 
          for each species in birds, respectively.
          Finish it by list comprehensions and conventional loops respectively. 
Usage: python lc1.py
Date: Oct, 2020

(13) lc2.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week2/Code
Function: Create a list of month,rainfall tuples where the amount of rain was greater than 100 mm.
          Create a list of just month names where the amount of rain was less than 50 mm.
          Be done by list comprehensions and conventional loops respectively.
Usage: python lc2.py
Date: Oct, 2020

(14) loops.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Script: loops.py
Work Path: CMEECourseWork/Week2/Code
Function: Exemplify the loops in python
Usage: python loops.py
Date: Oct, 2020

(15) oaks.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week2/Code
Function: Finds just those taxa that are oak trees from a list of species.
          Be done by list comprehensions or loops.
          Print results in lower or upper cases.
Usage: python oaks.py
Date: Oct, 2020

(16) scope.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week2/Code
Function: Exemplify variable scope
Usage: python scope.py
Date: Oct, 2020

(17) sysargv.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week2/Code
Dependencies: sys
Function: Exemplify use of sys and argv
Usage: python sysargv.py
Date: Oct, 2020

(18) test_control_flow.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week2/Code
Dependencies: sys, doctest
Function: Exemplify the use of control statement
Usage: python test_control_flow.py
Date: Oct, 2020

(19) tuple.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Work Path: CMEECourseWork/Week2/Code
Function: print latin name, common name, mass on a separate line
Usage: python tuple.py
Date: Oct, 2020

(20) using_name.py
Language: Python3
Auther: Cong Liu (cong.liu20@imperial.ac.uk)
Script: using_name.py
Work Path: CMEECourseWork/Week2/Code
Function: Exemplify the use of main()
Usage: python using_name.py
Date: Oct, 2020

Group work

(1) align_seqs_better.py
Programme that takes the DNA sequences from two (argued or default) FASTA files
and saves the best alignment(s) along with corresponding score(s) in a single
text file - includes alignments with partial overlap of strands at both ends.

(2) align_seqs_fasta.py
Programme that takes the DNA sequences from two (argued or default) FASTA files
and saves the best alignment along with the corresponding score in a single
text file - includes alignments with partial overlap of strands at both ends.

(3) oaks_debugme.py
Debug practice, where the bug prevents oaks from being found
Debug by writing doctests

