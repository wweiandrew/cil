// RUN: %clang_cc1 %s --std=c++11 -triple x86_64-unknown-linux -emit-llvm -o - \
// RUN:   -verify -fsyntax-only -verify-ignore-unexpected=note

#include "Inputs/cuda.h"

__global__ void kernel1();
__global__ void kernel2() {
  kernel1<<<1,1>>>(); // expected-error {{reference to __global__ function 'kernel1' in __global__ function}}
}