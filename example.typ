#import "main.typ": *
#set page(width: auto, height: 500pt)

#truth-table(order: "alphabetical",$u_7 => u_(22) => u$, $u_7 ? u_22 : u$)

#truth-table($A xor B$, $A and B$)    

#truth-table(order: "alphabetical reverse", $B and A$, $B or A$, $A => B$)

#truth-table($p => q$, $not p => (q <=> p)$, $p or q$, $not p xor q$)

#truth-table(sc: (a) => {if (a) {"a"} else {"b"}}, $a and b$)
#truth-table($A → B$)

#truth-table($p => p$, $(p => p) => p$, $p => (p => p)$)
#truth-table(align: center, sc: (T) => {if (T) {$T$} else {$F$}}, order: "alphabetical textbook", $q → r$, $(q → r) and (p or r)$, $p or r$, $p → q$, $(p → q) → r$)

#truth-table-empty(sc: (a) => {if (a) {"x"} else {"$"}}, ($a and b$,), (false, [], true))

#let A = $p or q$
#let B = $q -> r$
#let C = $p -> r$
#let leftHandSide = $(#A) -> (#B)$
#let rightHandSide = $not (#B) -> (#C)$
#truth-table(align: center, sc: (T) => {if (T) {$T$} else {$F$}}, order: "alphabetical textbook", A, B, leftHandSide, $not (#B)$, C, rightHandSide)
