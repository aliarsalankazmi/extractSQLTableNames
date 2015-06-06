# Extracting SQL Table Names
A function in R to extract Table names used in the FROM or JOIN clauses. I wrote this function as a Saturday afternoon task. The function enables entering a directory where all SQL or Txt files are located, which it then imports to R and applies a basic regex to extract table names in the **FROM** or **JOIN** clauses.

This function was formulated only to assist myself in a particular mundane task I had. Currently, it does not support removing comments from SQL, an implication of which is that any FROM clauses within comments may also be read.

