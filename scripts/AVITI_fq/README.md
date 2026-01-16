## Convert AVITI fastq files into a format loadable by latf-load

```
# compile
g++ -O3 -std=c++17 fq_rep_AVITI.cpp -lz -o fq_rep_AVITI 

# run
./fq_rep_AVITI.cpp dir_contains_AVITI_fastq/

# input and output
dir_contains_AVITI_fastq/input.fastq
-->
dir_contains_AVITI_fastq/input_r1.fastq
```

