// RUN: %ldc -c -output-ll -of=%t.ll %s && FileCheck %s < %t.ll

pragma(LDC_inline_ir)
    R inlineIREx(string prefix, string code, string suffix, R, P...)(P);

alias inlineIREx!("", "store i32 %1, i32* %0, !nontemporal !0", "!0 = !{i32 1}", void, int*, int) nontemporalStore;
alias inlineIREx!("!0 = !{i32 1}", "%i = load i32, i32* %0, !nontemporal !0\nret i32 %i", "", int, const int*) nontemporalLoad;

int foo(const int* src)
{
  // CHECK: %{{.*}} = load i32, i32* {{.*}} !nontemporal ![[METADATA:[0-9]+]]
  return nontemporalLoad(src);
}

void bar(int* dst, int val)
{
  // CHECK: store i32 {{.*}} !nontemporal ![[METADATA]]
  nontemporalStore(dst, val);
}

// CHECK: ![[METADATA]] = !{i32 1}