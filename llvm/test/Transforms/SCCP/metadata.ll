; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -ipsccp -S | FileCheck %s

declare void @use(i1)
declare i32 @get_i32()

define void @load_range(i32* %p) {
; CHECK-LABEL: @load_range(
; CHECK-NEXT:    [[V:%.*]] = load i32, i32* [[P:%.*]], align 4, !range !0
; CHECK-NEXT:    [[C1:%.*]] = icmp ult i32 [[V]], 10
; CHECK-NEXT:    call void @use(i1 [[C1]])
; CHECK-NEXT:    [[C2:%.*]] = icmp ult i32 [[V]], 9
; CHECK-NEXT:    call void @use(i1 [[C2]])
; CHECK-NEXT:    [[C3:%.*]] = icmp ugt i32 [[V]], 9
; CHECK-NEXT:    call void @use(i1 [[C3]])
; CHECK-NEXT:    [[C4:%.*]] = icmp ugt i32 [[V]], 8
; CHECK-NEXT:    call void @use(i1 [[C4]])
; CHECK-NEXT:    ret void
;
  %v = load i32, i32* %p, !range !{i32 0, i32 10}
  %c1 = icmp ult i32 %v, 10
  call void @use(i1 %c1)
  %c2 = icmp ult i32 %v, 9
  call void @use(i1 %c2)
  %c3 = icmp ugt i32 %v, 9
  call void @use(i1 %c3)
  %c4 = icmp ugt i32 %v, 8
  call void @use(i1 %c4)
  ret void
}

define void @load_nonnull(i32** %p) {
; CHECK-LABEL: @load_nonnull(
; CHECK-NEXT:    [[V:%.*]] = load i32*, i32** [[P:%.*]], align 8, !nonnull !1
; CHECK-NEXT:    [[C1:%.*]] = icmp ne i32* [[V]], null
; CHECK-NEXT:    call void @use(i1 [[C1]])
; CHECK-NEXT:    ret void
;
  %v = load i32*, i32** %p, !nonnull !{}
  %c1 = icmp ne i32* %v, null
  call void @use(i1 %c1)
  ret void
}

define void @call_range(i32* %p) {
; CHECK-LABEL: @call_range(
; CHECK-NEXT:    [[V:%.*]] = call i32 @get_i32(), !range !0
; CHECK-NEXT:    [[C1:%.*]] = icmp ult i32 [[V]], 10
; CHECK-NEXT:    call void @use(i1 [[C1]])
; CHECK-NEXT:    [[C2:%.*]] = icmp ult i32 [[V]], 9
; CHECK-NEXT:    call void @use(i1 [[C2]])
; CHECK-NEXT:    [[C3:%.*]] = icmp ugt i32 [[V]], 9
; CHECK-NEXT:    call void @use(i1 [[C3]])
; CHECK-NEXT:    [[C4:%.*]] = icmp ugt i32 [[V]], 8
; CHECK-NEXT:    call void @use(i1 [[C4]])
; CHECK-NEXT:    ret void
;
  %v = call i32 @get_i32(), !range !{i32 0, i32 10}
  %c1 = icmp ult i32 %v, 10
  call void @use(i1 %c1)
  %c2 = icmp ult i32 %v, 9
  call void @use(i1 %c2)
  %c3 = icmp ugt i32 %v, 9
  call void @use(i1 %c3)
  %c4 = icmp ugt i32 %v, 8
  call void @use(i1 %c4)
  ret void
}

define internal i1 @ip_cmp_range(i32 %v) {
; CHECK-LABEL: @ip_cmp_range(
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[V:%.*]], 10
; CHECK-NEXT:    ret i1 [[C]]
;
  %c = icmp ult i32 %v, 10
  ret i1 %c
}

define i1 @ip_load_range(i32* %p) {
; CHECK-LABEL: @ip_load_range(
; CHECK-NEXT:    [[V:%.*]] = load i32, i32* [[P:%.*]], align 4, !range !0
; CHECK-NEXT:    [[C:%.*]] = call i1 @ip_cmp_range(i32 [[V]])
; CHECK-NEXT:    ret i1 [[C]]
;
  %v = load i32, i32* %p, !range !{i32 0, i32 10}
  %c = call i1 @ip_cmp_range(i32 %v)
  ret i1 %c
}
