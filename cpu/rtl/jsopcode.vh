`define JSOP_NOP 8'd0			// Done
`define JSOP_PUSH 8'd1			// Done - must have undefined immediate
`define JSOP_POPV 8'd2
`define JSOP_ENTERWITH 8'd3
`define JSOP_LEAVEWITH 8'd4
`define JSOP_RETURN 8'd5
`define JSOP_GOTO 8'd6			// Done
`define JSOP_IFEQ 8'd7			// Done
`define JSOP_IFNE 8'd8			// Done
`define JSOP_ARGUMENTS 8'd9
`define JSOP_FORARG 8'd10
`define JSOP_FORLOCAL 8'd11
`define JSOP_DUP 8'd12			// Done 
`define JSOP_DUP2 8'd13			// Done
`define JSOP_SETCONST 8'd14
`define JSOP_BITOR 8'd15		// Done
`define JSOP_BITXOR 8'd16		// Done
`define JSOP_BITAND 8'd17		// Done
`define JSOP_EQ 8'd18			// Done
`define JSOP_NE 8'd19			// Done
`define JSOP_LT 8'd20			// Done
`define JSOP_LE 8'd21			// Done
`define JSOP_GT 8'd22			// Done
`define JSOP_GE 8'd23			// Done
`define JSOP_LSH 8'd24			// Done
`define JSOP_RSH 8'd25			// Done
`define JSOP_URSH 8'd26			// Done
`define JSOP_ADD 8'd27			// Done
`define JSOP_SUB 8'd28			// Done
`define JSOP_MUL 8'd29
`define JSOP_DIV 8'd30
`define JSOP_MOD 8'd31
`define JSOP_NOT 8'd32			// Done
`define JSOP_BITNOT 8'd33		// Done
`define JSOP_NEG 8'd34			// Done
`define JSOP_POS 8'd35
`define JSOP_DELNAME 8'd36
`define JSOP_DELPROP 8'd37
`define JSOP_DELELEM 8'd38
`define JSOP_TYPEOF 8'd39
`define JSOP_VOID 8'd40			// Done - must have undefined immediate
`define JSOP_INCNAME 8'd41
`define JSOP_INCPROP 8'd42
`define JSOP_INCELEM 8'd43
`define JSOP_DECNAME 8'd44
`define JSOP_DECPROP 8'd45
`define JSOP_DECELEM 8'd46
`define JSOP_NAMEINC 8'd47
`define JSOP_PROPINC 8'd48
`define JSOP_ELEMINC 8'd49
`define JSOP_NAMEDEC 8'd50
`define JSOP_PROPDEC 8'd51
`define JSOP_ELEMDEC 8'd52
`define JSOP_GETPROP 8'd53
`define JSOP_SETPROP 8'd54
`define JSOP_GETELEM 8'd55
`define JSOP_SETELEM 8'd56
`define JSOP_CALLNAME 8'd57
`define JSOP_CALL 8'd58
`define JSOP_NAME 8'd59
`define JSOP_DOUBLE 8'd60
`define JSOP_STRING 8'd61
`define JSOP_ZERO 8'd62			// Done - must have int:0 immediate
`define JSOP_ONE 8'd63			// Done - must have int:1 immediate
`define JSOP_NULL 8'd64			// Done - must have undefined immediate
`define JSOP_THIS 8'd65
`define JSOP_FALSE 8'd66		// Done - must have int:0 immediate
`define JSOP_TRUE 8'd67			// Done - must have int:1 immediate
`define JSOP_OR 8'd68
`define JSOP_AND 8'd69
`define JSOP_TABLESWITCH 8'd70
`define JSOP_LOOKUPSWITCH 8'd71
`define JSOP_STRICTEQ 8'd72
`define JSOP_STRICTNE 8'd73
`define JSOP_SETCALL 8'd74
`define JSOP_ITER 8'd75
`define JSOP_MOREITER 8'd76
`define JSOP_ENDITER 8'd77
`define JSOP_FUNAPPLY 8'd78
`define JSOP_SWAP 8'd79
`define JSOP_OBJECT 8'd80
`define JSOP_POP 8'd81			// Done
`define JSOP_NEW 8'd82
`define JSOP_TRAP 8'd83
`define JSOP_GETARG 8'd84
`define JSOP_SETARG 8'd85
`define JSOP_GETLOCAL 8'd86
`define JSOP_SETLOCAL 8'd87
`define JSOP_UINT16 8'd88
`define JSOP_NEWINIT 8'd89
`define JSOP_NEWARRAY 8'd90
`define JSOP_NEWOBJECT 8'd91
`define JSOP_ENDINIT 8'd92
`define JSOP_INITPROP 8'd93
`define JSOP_INITELEM 8'd94
`define JSOP_DEFSHARP 8'd95
`define JSOP_USESHARP 8'd96
`define JSOP_INCARG 8'd97
`define JSOP_DECARG 8'd98
`define JSOP_ARGINC 8'd99
`define JSOP_ARGDEC 8'd100
`define JSOP_INCLOCAL 8'd101
`define JSOP_DECLOCAL 8'd102
`define JSOP_LOCALINC 8'd103
`define JSOP_LOCALDEC 8'd104
`define JSOP_IMACOP 8'd105
`define JSOP_FORNAME 8'd106
`define JSOP_FORPROP 8'd107
`define JSOP_FORELEM 8'd108
`define JSOP_POPN 8'd109
`define JSOP_BINDNAME 8'd110
`define JSOP_SETNAME 8'd111
`define JSOP_THROW 8'd112
`define JSOP_IN 8'd113
`define JSOP_INSTANCEOF 8'd114
`define JSOP_DEBUGGER 8'd115
`define JSOP_GOSUB 8'd116
`define JSOP_RETSUB 8'd117
`define JSOP_EXCEPTION 8'd118
`define JSOP_LINENO 8'd119
`define JSOP_CONDSWITCH 8'd120
`define JSOP_CASE 8'd121
`define JSOP_DEFAULT 8'd122
`define JSOP_EVAL 8'd123
`define JSOP_ENUMELEM 8'd124
`define JSOP_GETTER 8'd125
`define JSOP_SETTER 8'd126
`define JSOP_DEFFUN 8'd127
`define JSOP_DEFCONST 8'd128
`define JSOP_DEFVAR 8'd129
`define JSOP_LAMBDA 8'd130
`define JSOP_CALLEE 8'd131
`define JSOP_SETLOCALPOP 8'd132
`define JSOP_PICK 8'd133
`define JSOP_TRY 8'd134
`define JSOP_FINALLY 8'd135
`define JSOP_GETFCSLOT 8'd136
`define JSOP_CALLFCSLOT 8'd137
`define JSOP_ARGSUB 8'd138
`define JSOP_ARGCNT 8'd139
`define JSOP_DEFLOCALFUN 8'd140
`define JSOP_GOTOX 8'd141
`define JSOP_IFEQX 8'd142
`define JSOP_IFNEX 8'd143
`define JSOP_ORX 8'd144
`define JSOP_ANDX 8'd145
`define JSOP_GOSUBX 8'd146
`define JSOP_CASEX 8'd147
`define JSOP_DEFAULTX 8'd148
`define JSOP_TABLESWITCHX 8'd149
`define JSOP_LOOKUPSWITCHX 8'd150
`define JSOP_BACKPATCH 8'd151
`define JSOP_BACKPATCH_POP 8'd152
`define JSOP_THROWING 8'd153
`define JSOP_SETRVAL 8'd154
`define JSOP_RETRVAL 8'd155
`define JSOP_GETGNAME 8'd156
`define JSOP_SETGNAME 8'd157
`define JSOP_INCGNAME 8'd158
`define JSOP_DECGNAME 8'd159
`define JSOP_GNAMEINC 8'd160
`define JSOP_GNAMEDEC 8'd161
`define JSOP_REGEXP 8'd162
`define JSOP_DEFXMLNS 8'd163
`define JSOP_ANYNAME 8'd164
`define JSOP_QNAMEPART 8'd165
`define JSOP_QNAMECONST 8'd166
`define JSOP_QNAME 8'd167
`define JSOP_TOATTRNAME 8'd168
`define JSOP_TOATTRVAL 8'd169
`define JSOP_ADDATTRNAME 8'd170
`define JSOP_ADDATTRVAL 8'd171
`define JSOP_BINDXMLNAME 8'd172
`define JSOP_SETXMLNAME 8'd173
`define JSOP_XMLNAME 8'd174
`define JSOP_DESCENDANTS 8'd175
`define JSOP_FILTER 8'd176
`define JSOP_ENDFILTER 8'd177
`define JSOP_TOXML 8'd178
`define JSOP_TOXMLLIST 8'd179
`define JSOP_XMLTAGEXPR 8'd180
`define JSOP_XMLELTEXPR 8'd181
`define JSOP_NOTRACE 8'd182
`define JSOP_XMLCDATA 8'd183
`define JSOP_XMLCOMMENT 8'd184
`define JSOP_XMLPI 8'd185
`define JSOP_DELDESC 8'd186
`define JSOP_CALLPROP 8'd187
`define JSOP_BLOCKCHAIN 8'd188
`define JSOP_NULLBLOCKCHAIN 8'd189
`define JSOP_UINT24 8'd190
`define JSOP_INDEXBASE 8'd191
`define JSOP_RESETBASE 8'd192
`define JSOP_RESETBASE0 8'd193
`define JSOP_STARTXML 8'd194
`define JSOP_STARTXMLEXPR 8'd195
`define JSOP_CALLELEM 8'd196
`define JSOP_STOP 8'd197
`define JSOP_GETXPROP 8'd198
`define JSOP_CALLXMLNAME 8'd199
`define JSOP_TYPEOFEXPR 8'd200
`define JSOP_ENTERBLOCK 8'd201
`define JSOP_LEAVEBLOCK 8'd202
`define JSOP_IFCANTCALLTOP 8'd203
`define JSOP_PRIMTOP 8'd204
`define JSOP_GENERATOR 8'd205
`define JSOP_YIELD 8'd206
`define JSOP_ARRAYPUSH 8'd207
`define JSOP_GETFUNNS 8'd208
`define JSOP_ENUMCONSTELEM 8'd209
`define JSOP_LEAVEBLOCKEXPR 8'd210
`define JSOP_GETTHISPROP 8'd211
`define JSOP_GETARGPROP 8'd212
`define JSOP_GETLOCALPROP 8'd213
`define JSOP_INDEXBASE1 8'd214
`define JSOP_INDEXBASE2 8'd215
`define JSOP_INDEXBASE3 8'd216
`define JSOP_CALLGNAME 8'd217
`define JSOP_CALLLOCAL 8'd218
`define JSOP_CALLARG 8'd219
`define JSOP_BINDGNAME 8'd220
`define JSOP_INT8 8'd221		// Done - must have int:blah immediate
`define JSOP_INT32 8'd222		// Done - must have int:blah immediate
`define JSOP_LENGTH 8'd223
`define JSOP_HOLE 8'd224
`define JSOP_DEFFUN_FC 8'd225
`define JSOP_DEFLOCALFUN_FC 8'd226
`define JSOP_LAMBDA_FC 8'd227
`define JSOP_OBJTOP 8'd228
`define JSOP_TRACE 8'd229
`define JSOP_SETMETHOD 8'd230
`define JSOP_INITMETHOD 8'd231
`define JSOP_UNBRAND 8'd232
`define JSOP_UNBRANDTHIS 8'd233
`define JSOP_SHARPINIT 8'd234
`define JSOP_GETGLOBAL 8'd235
`define JSOP_CALLGLOBAL 8'd236
`define JSOP_FUNCALL 8'd237
`define JSOP_FORGNAME 8'd238
