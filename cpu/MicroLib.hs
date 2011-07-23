module MicroLib where
import Data.List

data MicroInsn = MI {r1 :: R1,
                     r0 :: R0,
                     br :: BR,
                     l  :: L,
                     r  :: R,
                     push :: Push,
                     pop :: Pop,
                     alu :: ALU,
                     done :: Done}
m :: MicroInsn
m = MI UC_R1_NOP UC_R0_NOP UC_BR_NONE UC_LEFT_IMM UC_RIGHT_IMM UC_NOPUSH (UC_POP 0) ALU_LEFT UC_DONE

instance Show MicroInsn where
  show (MI a b c d e f g h i) = "\t{ 13'b0, " ++ (intercalate ", " (map (('`':)) [show a, show b, show c, show d, show e, show f, show g, show h, show i])) ++ " }\n"

data R1 = UC_R1_NOP | UC_R1_STORE deriving Show
data R0 = UC_R0_NOP | UC_R0_STORE deriving Show
data BR = UC_BR_REL | UC_BR_NONE | UC_BR_REL_COND deriving Show
data L = UC_LEFT_IMM | UC_LEFT_STK0 | UC_LEFT_STK1 deriving Show
data R = UC_RIGHT_IMM | UC_RIGHT_STK0 | UC_RIGHT_STK1 deriving Show
data Push = UC_NOPUSH | UC_PUSHALU | UC_PUSHIMM | UC_PUSHREG0 | UC_PUSHREG1 deriving Show
data Pop = UC_POP Int
data ALU = ALU_LEFT | ALU_RIGHT | ALU_BITOR | ALU_BITXOR | ALU_BITAND | ALU_EQ | ALU_NE | ALU_LT | ALU_LE | ALU_GT | ALU_GE | ALU_LSH | ALU_RSH | ALU_URSH | ALU_ADD | ALU_SUB | ALU_LEFT_EQZ | ALU_LEFT_NEZ | ALU_NOT | ALU_BITNOT | ALU_NEG deriving Show
data Done = UC_DONE | UC_NEXT deriving Show

instance Show Pop where
  show (UC_POP n) = "UC_POP(2'd" ++ (show n) ++ ")"

format :: [(String, [MicroInsn])] -> String
format xs = "\t{ 32'b0 }\n" ++ (concatMap formatStep xs)

formatStep (n, []) = n ++ "\n"
formatStep (n, foos) = n ++ "\n" ++ (concatMap show (reify foos)) ++ "\n"

reify [] = []
reify xs = (map (\x -> x {done = UC_NEXT}) (init xs)) ++ [last xs]

