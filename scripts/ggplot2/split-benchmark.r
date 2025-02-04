#
# JVM Performance Benchmarks
#
# Copyright (C) 2019 - 2023 Ionut Balosin
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

# Load the necessary utilities
source("./scripts/ggplot2/split-utils.r")

# Retrieve command line arguments in a very specific order
args <- commandArgs(TRUE)
if (length(args) != 5) {
  stop("Usage: Rscript script.R <jmh_output_folder>
        <openjdk_hotspot_vm_identifier> <graalvm_ce_identifier> <graalvm_ee_identifier> <azul_prime_vm_identifier>")
}
jmh_output_folder <- args[1]
jvm_identifiers <- args[2:5]

# Define a function to split and process benchmarks
splitAndProcessBenchmark <- function(benchmark_file, param_name, column_values) {
  column_name <- paste("Param..", param_name, sep = "")
  for (jvm_identifier in jvm_identifiers) {
    benchmark_name <- sub("\\.csv$", "", benchmark_file)
    output_file <- paste(
      benchmark_name,
      "param",
      param_name,
      paste(column_values, sep = "_"),
      sep = "_"
    )
    output_file <- paste(output_file, ".csv", sep = "")
    splitAndWriteBenchmarkResultsToFile(jmh_output_folder, jvm_identifier, benchmark_file, column_name, column_values, output_file)
  }
}

# Split and process FactorialBenchmark
splitAndProcessBenchmark("FactorialBenchmark.csv", "n", list("1000"))
splitAndProcessBenchmark("FactorialBenchmark.csv", "n", list("5000"))

# Split and process FibonacciBenchmark
splitAndProcessBenchmark("FibonacciBenchmark.csv", "n", list("500"))
splitAndProcessBenchmark("FibonacciBenchmark.csv", "n", list("3000"))

# Split and process NpeControlFlowBenchmark
splitAndProcessBenchmark("NpeControlFlowBenchmark.csv", "nullThreshold", list("0"))
splitAndProcessBenchmark("NpeControlFlowBenchmark.csv", "nullThreshold", list("16"))

# Split and process SortVectorApiBenchmark
splitAndProcessBenchmark("SortVectorApiBenchmark.csv", "arraySize", list("64"))
splitAndProcessBenchmark("SortVectorApiBenchmark.csv", "arraySize", list("1024"))
splitAndProcessBenchmark("SortVectorApiBenchmark.csv", "arraySize", list("65536"))

# Split and process VectorApiBenchmark
splitAndProcessBenchmark("VectorApiBenchmark.csv", "size", list("262144"))
splitAndProcessBenchmark("VectorApiBenchmark.csv", "size", list("1048576"))
