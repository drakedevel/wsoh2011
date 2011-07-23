{-# LANGUAGE CPP #-}
#define MICRO2(opa, opb) ("opa", [m {l = UC_LEFT_STK0, r = UC_RIGHT_STK1, push = UC_PUSHALU, pop = UC_POP 2, alu = opb}]),
module Microprogram where
import MicroLib
microprogram =
 [("JSOP_NOP", [m]),
  ("JSOP_GOTO", [m {br = UC_BR_REL}]),
  ("JSOP_IFEQ", [m {br = UC_BR_REL_COND, l = UC_LEFT_STK0, alu = ALU_LEFT_EQZ}]),
  ("JSOP_IFNE", [m {br = UC_BR_REL_COND, l = UC_LEFT_STK0, alu = ALU_LEFT_NEZ}]),
  ("JSOP_PUSH", []),
  ("JSOP_ZERO", []),
  ("JSOP_ONE", []),
  ("JSOP_FALSE", []),
  ("JSOP_TRUE", []),
  ("JSOP_NULL", []),
  ("JSOP_INT8", []),
  ("JSOP_INT32", []),
  ("JSOP_UINT16", [m {push = UC_PUSHIMM}]),
  ("JSOP_DUP", [m {l = UC_LEFT_STK0, push = UC_PUSHALU}]),
  ("JSOP_DUP2", replicate 2 $ m {l = UC_LEFT_STK1, push = UC_PUSHALU}),
  MICRO2(JSOP_BITOR, ALU_BITOR)
  MICRO2(JSOP_BITXOR, ALU_BITXOR)
  MICRO2(JSOP_BITAND, ALU_BITAND)
  MICRO2(JSOP_EQ, ALU_EQ)
  MICRO2(JSOP_NE, ALU_NE)
  MICRO2(JSOP_LT, ALU_LT)
  MICRO2(JSOP_LE, ALU_LE)
  MICRO2(JSOP_GT, ALU_GT)
  MICRO2(JSOP_GE, ALU_GE)
  MICRO2(JSOP_LSH, ALU_LSH)
  MICRO2(JSOP_URSH, ALU_URSH)
  MICRO2(JSOP_ADD, ALU_ADD)
  MICRO2(JSOP_SUB, ALU_SUB)
  ("JSOP_NOT", [m {l =UC_LEFT_STK0, pop = UC_POP 1, alu = ALU_NOT}]),
  ("JSOP_BITNOT", [m {l = UC_LEFT_STK0, pop = UC_POP 1, alu = ALU_NOT}]),
  ("JSOP_NEG", [m {l = UC_LEFT_STK0, pop = UC_POP 1, alu = ALU_NEG}]),
  ("JSOP_VOID", [m {pop = UC_POP 1}]),
  ("JSOP_SWAP", [m {r0 = UC_R0_STORE, r1 = UC_R1_STORE, push = UC_PUSHREG0, pop = UC_POP 2}, m {push = UC_PUSHREG1}]),
  ("OP_NOP", [m]),
  ("OP_PUSHI", [m {push = UC_PUSHALU}]),
  ("OP_PUSHV", [m {push = UC_PUSHIMM}]),
  ("OP_BITAND", [m {l = UC_LEFT_STK0, r = UC_RIGHT_STK1, pop = UC_POP 2, alu = ALU_BITAND}]),
  ("OP_GOTO", [m {br = UC_BR_REL}])]
