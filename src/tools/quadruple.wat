;; Template for defining 'word' modules
;; Used to 'reverse engineer' the binary code to emit from the compiler
(module
  (import "env" "table" (table 4 anyfunc))
  (import "env" "tableBase" (global $tableBase i32))
  (import "env" "memory" (memory 1))
  (import "env" "tos" (global $tos i32))

  (type $word (func (param i32) (param i32) (result i32)))
  (type $push (func (param i32)))
  (type $pop (func (result i32)))

  (func $word (param $tosIn i32) (param $n i32) (result i32)
    (local $index1 i32)
    (local $end1 i32)

    ;; Push
    (call_indirect (type $push) (i32.const 43) (i32.const 1))

    ;; Word call
    (call_indirect (type $word) (i32.const 10) (i32.const 11) (i32.const 9))
    (drop)

    ;; Conditional
    (if (i32.ne (call_indirect (type $pop) (i32.const 2)) (i32.const 0))
      (then
        (nop)
        (nop))
      (else
        (nop)
        (nop)
        (nop)))

    ;; do loop
    (set_local $index1 (call_indirect (type $pop) (i32.const 2)))
    (set_local $end1 (call_indirect (type $pop) (i32.const 2)))
    (block $endDoLoop
      (loop $doLoop
        (nop)
        (set_local $index1 (i32.add (get_local $index1) (i32.const 1)))
        (br_if $endDoLoop (i32.ge_s (get_local $index1) (get_local $end1)))
        (br $doLoop)))

    ;; repeat loop
    (block $endRepeatLoop
      (loop $repeatLoop
        (nop)
        (br_if $endRepeatLoop (i32.eqz (call_indirect (type $pop) (i32.const 2))))
        (nop)
        (br $repeatLoop)))
    
    (call $word (i32.const 11) (get_local $n)))

  (elem (get_global $tableBase) $word))
