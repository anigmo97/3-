;; =========================================================
;; ===   BY AKSHAY PUNJABI & PABLO IZQUIERDO AYALA        ==
;; =========================================================

(defglobal 
	?*nod-gen* = 0
	?*neighbourhood* = (create$ A 1 B 2 C 2 D 2 E 2 J 2 F 3 G 3 H 3 I 3 O 3 K 4 L 4 M 4 N 4 P 5 Q 5 R 6)
	?*minlist* = (create$ A 8 B 5 C 5 D 6 E 9 J 7 F 6 G 6 H 6 I 2 O 2 K 2 L 2 M 2 N 6 P 2 Q 2 R 3) 
	?*f* = 1)

(deffacts datos

	(bikepoint A)(bikepoint B)(bikepoint J)(bikepoint H)
	(bikepoint K)(bikepoint M)(bikepoint N)(bikepoint R)
	
 	(can_cycle A B cost 10) (can_cycle B A cost 10)
	(can_cycle A E cost 10) (can_cycle E A cost 10)
	(can_cycle D H cost 14) (can_cycle H D cost 14)
	(can_cycle E J cost 9) (can_cycle J E cost 9)
	(can_cycle J O cost 7) (can_cycle O J cost 7)
	(can_cycle H I cost 12) (can_cycle I H cost 12)
	(can_cycle K L cost 2) (can_cycle L K cost 2)
	(can_cycle L M cost 7) (can_cycle M L cost 7)
	(can_cycle L P cost 6) (can_cycle P L cost 6)
	(can_cycle P R cost 4) (can_cycle R P cost 4)
	(can_cycle O N cost 8) (can_cycle N O cost 8)
	
	(can_walk A C cost 8) (can_walk C A cost 8)
	(can_walk B F cost 6) (can_walk F B cost 6)
	(can_walk B C cost 5) (can_walk C B cost 5)
	(can_walk C G cost 6) (can_walk G C cost 6)
	(can_walk C D cost 6) (can_walk D C cost 6)
	(can_walk C H cost 6) (can_walk H C cost 6)
	(can_walk E I cost 20) (can_walk I E cost 20)
	(can_walk I O cost 2) (can_walk O I cost 2)
	(can_walk F K cost 10) (can_walk K F cost 10)
	(can_walk F L cost 6) (can_walk L F cost 6)
	(can_walk G L cost 9) (can_walk L G cost 9)
	(can_walk G M cost 12) (can_walk M G cost 12)
	(can_walk G H cost 8) (can_walk H G cost 8)
	(can_walk M Q cost 2) (can_walk Q M cost 2)
	(can_walk N Q cost 6) (can_walk Q N cost 6)
	(can_walk P Q cost 2) (can_walk Q P cost 2)
	(can_walk Q R cost 3) (can_walk R Q cost 3)	) 

(deffunction bikepoint (?n)
	(bind ?res 0)
	(if (eq ?n A) then (bind ?res 1))
	(if (eq ?n B) then (bind ?res 1))
	(if (eq ?n J) then (bind ?res 1))
	(if (eq ?n K) then (bind ?res 1))
	(if (eq ?n H) then (bind ?res 1))
	(if (eq ?n M) then (bind ?res 1))
	(if (eq ?n N) then (bind ?res 1))
	(if (eq ?n R) then (bind ?res 1))
	?res)	
	
(deffunction heuristic (?state)
	(bind ?result 0)
	(bind ?n (nth$ 1 ?state))
	(bind ?hasbike (nth$ 2 ?state))
	(bind ?destin (nth$ 3 ?state))

	;distneigh(n)
	(bind ?origin (nth$ (+ (member ?n ?*neighbourhood*) 1) ?*neighbourhood*))
	(bind ?destination (nth$ (+ (member ?destin ?*neighbourhood*) 1) ?*neighbourhood*))
	(bind ?diff (abs (- ?origin ?destination)))
	;same neigh	
	(if ( = ?diff 0)then (bind ?distneigh  1))
	;otherwise
	(if ( <> ?diff 0)then (bind ?distneigh ?diff))
	
	;cam(n) 
	(bind ?mincam (nth$ (+ (member ?n ?*minlist*) 1) ?*minlist*))
	
	;sit(n)
	;hasbike 1
	(if (= ?hasbike 1) then (bind ?sit 0.5))
	;hasbike 0 (otherwise)
	(if (<> ?hasbike 1) then (bind ?sit 1))
	;at a bikepoint
	(if (= (bikepoint ?n) 1) then (bind ?sit 0.5))
	
	;final result
	(if(neq ?n ?destin) then (bind ?result (integer (* ?distneigh ?mincam ?sit))))
	  ?result)
	

(deffunction control (?state ?cost)
	(bind ?*f* (heuristic ?state))
	(bind ?*f* (+ ?*f* ?cost))
	(printout t "prioridad" ?*f* crlf)
)

(defrule walk
	(declare (salience (- 0 ?*f*)))
	(citybikes place ?p hasbike 0 level ?level past ?a totalcost ?tcost)
	(destination ?m)
	(or (can_walk ?p ?dest cost ?cost)(can_cycle ?p ?dest cost ?cost))
	(test (neq ?a ?dest))
	(test (control (create$ ?dest 0 ?m) (+ ?tcost ?cost)))
	 =>
 	(assert (citybikes place ?dest hasbike 0 level (+ ?level 1) past ?p totalcost (+ ?tcost ?cost)))
	 (printout t "voy a pie")
	 (printout t " past" ?a crlf)
	(bind ?*nod-gen* (+ ?*nod-gen* 1)))

 (defrule cycle
	(declare (salience (- 0 ?*f*)))
	(citybikes place ?p hasbike 1 level ?level past ?a totalcost ?tcost)
	(destination ?m)
 	(can_cycle ?p ?dest cost ?cost)
	(test (neq ?a ?dest))
	(test (control (create$ ?dest 1 ?m) (+ ?tcost (div ?cost 2))))
	 =>
 	(assert (citybikes place ?dest hasbike 1 level (+ ?level 1) past ?p totalcost (+ ?tcost (div ?cost 2))))
	 (printout t "voy a bici")
	 (printout t " past" ?a crlf)
	(bind ?*nod-gen* (+ ?*nod-gen* 1)))


 (defrule take-bike
	(declare (salience (- 0 ?*f*)))
 	(citybikes place ?p hasbike ?hasbike level ?level past ?a totalcost ?tcost)
	(destination ?m)
	(bikepoint ?p)
	(test (= ?hasbike 0))
	(test (neq ?a ?p))
	(test (control (create$ ?p 1 ?m) (+ ?tcost 1)))
 	=>
 	(assert (citybikes place ?p hasbike 1 level (+ ?level 1) past ?a totalcost (+ ?tcost 1)))
	  (printout t "cojo bici")
	  (printout t " past" ?a crlf)
	(bind ?*nod-gen* (+ ?*nod-gen* 1)))

 (defrule drop-bike
	(declare (salience (- 0 ?*f*)))
	(destination ?m)
 	(citybikes place ?p hasbike ?hasbike level ?level past ?a totalcost ?tcost)
	(bikepoint ?p)
	(test (= ?hasbike 1))
	(test (neq ?a ?p))
	(test (neq ?a null))
	(test (control (create$ ?p 0 ?m) (+ ?tcost 1)))
 	=>
 	(assert (citybikes place ?p hasbike 0 level (+ ?level 1) past ?a totalcost (+ ?tcost 1)))
	  (printout t "dejo bici")
	  (printout t " past" ?a crlf)
	(bind ?*nod-gen* (+ ?*nod-gen* 1)))

(defrule stop
 	(declare (salience 100))
 	(citybikes place ?dest hasbike 0 level ?level past ?a totalcost ?tcost)
 	(destination ?dest)
 	=>
	(printout t "SOLUTION FOUND AT LEVEL " ?level crlf)
    	(printout t "NUMBER OF EXPANDED NODES OR TRIGGERED RULES " ?*nod-gen* crlf)
    	(printout t "COST OF THE SOLUTION " ?tcost crlf)

 	(halt))
	
(deffunction ispoint(?p)
	(bind ?nodes (create$ A B C D E F G H I J K L M N O P Q R))
	(bind ?result 1)
	(if(eq (member ?p ?nodes) FALSE) then (bind ?result 0))
	?result)

(deffunction askorigin()
	(printout t "Origin point:= ")
	(bind ?ini (read))
	(if (= (ispoint ?ini) 0)
		then (printout t "The character specified its not a valid point." crlf)
			 (askorigin)
	)
?ini)
	
(deffunction askdestination()
	(printout t "Destination point:= ")
	(bind ?fin (read))
	(if (= (ispoint ?fin) 0)
		then (printout t "The character specified its not a valid point." crlf)
			 (askdestination)
	)
?fin)

(deffunction start ()
	(set-salience-evaluation when-activated)
        (reset)
	(bind ?ini (askorigin))
	(bind ?fin (askdestination))
	(assert (citybikes place ?ini hasbike 0 level 0 past null totalcost 0))
	(assert (destination ?fin))
        (printout t " Execute run to start the program " crlf)
	
)
	