; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -S -passes='attributor' -aa-pipeline='basic-aa' -attributor-disable=false -attributor-max-iterations-verify -attributor-max-iterations=4 < %s | FileCheck %s
; PR14710

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

%pair = type { i32, i32 }

declare i8* @foo(%pair*)

define internal void @bar(%pair* byval %Data) {
; CHECK-LABEL: define {{[^@]+}}@bar
; CHECK-SAME: (i32 [[TMP0:%.*]], i32 [[TMP1:%.*]])
; CHECK-NEXT:    [[DATA_PRIV:%.*]] = alloca [[PAIR:%.*]]
; CHECK-NEXT:    [[DATA_PRIV_CAST:%.*]] = bitcast %pair* [[DATA_PRIV]] to i32*
; CHECK-NEXT:    store i32 [[TMP0]], i32* [[DATA_PRIV_CAST]]
; CHECK-NEXT:    [[DATA_PRIV_0_1:%.*]] = getelementptr [[PAIR]], %pair* [[DATA_PRIV]], i32 0, i32 1
; CHECK-NEXT:    store i32 [[TMP1]], i32* [[DATA_PRIV_0_1]]
; CHECK-NEXT:    [[TMP3:%.*]] = call i8* @foo(%pair* [[DATA_PRIV]])
; CHECK-NEXT:    ret void
;
  tail call i8* @foo(%pair* %Data)
  ret void
}

define void @zed(%pair* byval %Data) {
; CHECK-LABEL: define {{[^@]+}}@zed
; CHECK-SAME: (%pair* noalias nocapture readonly byval [[DATA:%.*]])
; CHECK-NEXT:    [[DATA_CAST:%.*]] = bitcast %pair* [[DATA]] to i32*
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[DATA_CAST]], align 1
; CHECK-NEXT:    [[DATA_0_1:%.*]] = getelementptr [[PAIR:%.*]], %pair* [[DATA]], i32 0, i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[DATA_0_1]], align 1
; CHECK-NEXT:    call void @bar(i32 [[TMP1]], i32 [[TMP2]])
; CHECK-NEXT:    ret void
;
  call void @bar(%pair* byval %Data)
  ret void
}